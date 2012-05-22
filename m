Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab2EVR0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:26:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:39493 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2EVR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:26:43 -0400
Date: Tue, 22 May 2012 19:26:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Avi Kivity <avi@redhat.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
In-Reply-To: <4FBB7185.6040105@redhat.com>
Message-ID: <alpine.LFD.2.02.1205221919260.3231@ionos>
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos> <4FBB7185.6040105@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Avi Kivity wrote:
> On 05/22/2012 12:04 AM, Thomas Gleixner wrote:
> > The only justification for having the same layout as the actual
> > hardware is when you are going to map the memory into the guest space,
> > which is not the case here.
>
> The APIC page is in fact mapped  to the hardware (not the guest, but vmx
> microcode does access it).  Only one register, the TPR, is ever used. 
> It's possible to re-layout the data structure so that the TPR stays in
> the same place while everything else becomes contiguous, but we'll have
> to do it again if the hardware starts mapping more registers.

I would avoid that by having a compressed version which reflects the
SW state and the mapped one which allows the vmx microcode to fiddle
with the TPR. If you need more registers in the HW page then you don't
have to worry about the layout and just have a proper accessor for
that.

Thanks,

	tglx
