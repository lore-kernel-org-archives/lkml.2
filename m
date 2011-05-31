Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1EaKhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:37:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60758 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1EaKhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:37:52 -0400
Date: Tue, 31 May 2011 12:38:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
Message-ID: <20110531103808.GA6915@eferding.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Brad Campbell <lists2009@fnarfbargle.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Izik Eidus <ieidus@redhat.com>
References: <4DE44333.9000903@fnarfbargle.com>
 <20110531054729.GA16852@liondog.tnic>
 <4DE4B432.1090203@fnarfbargle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DE4B432.1090203@fnarfbargle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 05:26:10PM +0800, Brad Campbell wrote:
> On 31/05/11 13:47, Borislav Petkov wrote:
> >Looks like a KSM issue. Disabling CONFIG_KSM should at least stop your
> >machine from oopsing.
> >
> >Adding linux-mm.
> >
> 
> I initially thought that, so the second panic was produced with KSM
> disabled from boot.
> 
> echo 0 > /sys/kernel/mm/ksm/run
> 
> If you still think that compiling ksm out of the kernel will prevent
> it then I'm willing to give it a go.

Ok, from looking at the code, when KSM inits, it starts the ksm kernel
thread and it looks like your oops comes from the function that is run
in the kernel thread - ksm_scan_thread.

So even if you disable it from sysfs, it runs at least once.

Let's add some more people to Cc and see what happens :).

-- 
Regards/Gruss,
Boris.
