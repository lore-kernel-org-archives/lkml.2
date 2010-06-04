Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0FDOtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab0FDOtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:49:39 -0400
Date: Fri, 4 Jun 2010 10:49:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/5] kdump: extract log buffer and registers from
	vmcore on NMI button pressing
Message-ID: <20100604144921.GG4111@redhat.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com> <20100602151611.GA3174@redhat.com> <87iq60a3rh.wl%vmayatsk@redhat.com> <87d3w8xy3q.fsf@basil.nowhere.org> <874ohkuwhs.wl%vmayatsk@redhat.com> <20100603151347.GC4166@basil.fritz.box> <20100604094936.GA5975@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100604094936.GA5975@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 05:49:36PM +0800, Américo Wang wrote:
> On Thu, Jun 03, 2010 at 05:13:47PM +0200, Andi Kleen wrote:
> >> > NMI would be only needed if the crash kernel is completely
> >> > hosed too.
> >> 
> >> That's the case.
> >
> >You're saying it booted but is hosed after boot?
> >
> >That seems like a very obscure case. Is that really common?
> >
> 
> Actually, I met two of this kind of cases recently.
> 
> One was stucked in early_idt_hander() during booting the second kernel,
> the other one is even worse, I even can't find where it hangs.

If you can't initialize the idt, will NMI work?

I think we need to fix those cases instead of creating another NMI
handler. To handle cases like network is not up or there is not sufficient
space on disk, a user space utility in kdump initrd should work.

Thanks
Vivek

