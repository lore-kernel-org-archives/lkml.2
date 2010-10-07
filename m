Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0JGQV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 12:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab0JGQV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:21:26 -0400
Message-ID: <4CADF365.3080406@redhat.com>
Date: Thu, 07 Oct 2010 18:20:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@minantech.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org
Subject: Re: [PATCH v6 04/12] Add memory slot versioning and use it to provide
 fast guest write interface
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-5-git-send-email-gleb@redhat.com> <20101005165738.GA32750@amt.cnet> <20101006111417.GX11145@redhat.com> <20101006143847.GB31423@amt.cnet> <20101006200836.GC4120@minantech.com> <4CAD9A2D.7020009@redhat.com> <20101007154248.GA30949@amt.cnet> <20101007160340.GD4120@minantech.com>
In-Reply-To: <20101007160340.GD4120@minantech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/07/2010 06:03 PM, Gleb Natapov wrote:
> >  >
> >  >  Isn't SET_USER_MEMORY_REGION so slow that calling it 2^32 times
> >  >  isn't really feasible?
> >
> >  Assuming it takes 1ms, it would take 49 days.
> >
> We may fail ioctl when max value is reached. The question is how much slot
> changes can we expect from real guest during its lifetime.
>

A normal guest has a 30 Hz timer for reading the vga framebuffer, 
multiple slots.  Let's assume 100 Hz frequency, that gives 490 days 
until things stop working.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

