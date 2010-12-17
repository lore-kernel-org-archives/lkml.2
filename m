Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0LQQP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:15:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab0LQQPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:15:25 -0500
Date: Fri, 17 Dec 2010 11:15:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101217161505.GB9568@redhat.com>
References: <4D0663F0.2060103@kernel.org>
 <4D06783C.6040009@zytor.com>
 <20101214224135.GB19693@redhat.com>
 <20101215103954.GA2243@redhat.com>
 <4D09958D.2040907@kernel.org>
 <20101216143925.GA13870@redhat.com>
 <4D0A3E31.4000109@zytor.com>
 <4D0A4C51.3070008@kernel.org>
 <20101216220117.GA2485@redhat.com>
 <4D0A9986.4080209@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0A9986.4080209@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 02:58:14PM -0800, Yinghai Lu wrote:
> On 12/16/2010 02:01 PM, Vivek Goyal wrote:
> > On Thu, Dec 16, 2010 at 09:28:49AM -0800, Yinghai Lu wrote:
> >> On 12/16/2010 08:28 AM, H. Peter Anvin wrote:
> >>> On 12/16/2010 06:39 AM, Vivek Goyal wrote:
> >>>> On Wed, Dec 15, 2010 at 08:29:01PM -0800, Yinghai Lu wrote:
> >>>>> please check
> >>>>>
> >>>>> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
> >>>>>
> >>>>> Steanishlaw report kdump is 32bit is broken.
> >>>>>
> >>>>> in misc.c for decompresser, it will do sanity checking to make sure heap
> >>>>> heap under 512M.
> >>>>
> >>>> Thanks Yinghai. I am wondering why on 32bit heap has to be with-in 512MB.
> >>>> I think you are referring to following check in
> >>>> arch/x86/boot/compressed/misc.c.
> >>>>
> >>>> 	if (end > ((-__PAGE_OFFSET-(512 <<20)-1) & 0x7fffffff))
> >>>> 		error("Destination address too large");
> >>>>
> >>>> It was introduced here.
> >>>>
> >>>> commit 968de4f02621db35b8ae5239c8cfc6664fb872d8
> >>>> Author: Eric W. Biederman <ebiederm@xmission.com>
> >>>> Date:   Thu Dec 7 02:14:04 2006 +0100
> >>>>
> >>>>     [PATCH] i386: Relocatable kernel support
> >>>>
> >>>> Eric,
> >>>>
> >>>> It has been long. By any chance would you remember where does above
> >>>> constraint come from?
> >>>>
> >>>
> >>> It might, in fact, be bogus; specifically a proxy for the fact that we
> >>> need the kernel memory including bss and brk below the lowmem boundary,
> >>> which isn't well-defined.
> >>
> >> the brk is complaining if i change that to 
> >>
> >>  	if (end > ((-__PAGE_OFFSET-(128 <<20)-1) & 0x7fffffff))
> >>  		error("Destination address too large");
> >>
> > 
> > Yinghai, 
> > 
> > On my system above change works fine and I can boot into second kernel. So
> > it will boil down to knowing what are the exact constraints on heap for
> > decompression and for 32bit can we allow heap upto 896MB or not.
> 
> really? what is you CONFIG_PAGE_OFFSET? 0x40000000 or 0xc0000000?
> 

I am using CONFIG_PAGE_OFFSET=0xC0000000

Thanks
Vivek
