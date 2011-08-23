Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1HWSn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:43:27 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58234 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1HWSnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:43:21 -0400
Date: Tue, 23 Aug 2011 11:41:48 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Fabio M . Di Nitto" <fabbione@fabbione.net>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] kernel/printk: do not turn off bootconsole in
 printk_late_init if keep_bootcon
Message-ID: <20110823184148.GB3082@us.ibm.com>
References: <1312934553-17085-1-git-send-email-nacc@us.ibm.com>
 <20110819171024.7805dec6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819171024.7805dec6.akpm@linux-foundation.org>
X-Operating-System: Linux 2.6.38-11-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 19.08.2011 [17:10:24 -0700], Andrew Morton wrote:
> On Tue,  9 Aug 2011 17:02:33 -0700
> Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> 
> > It seems that commit 7bf693951a8e5f7e600a45b74d91d962a453146e doesn't
> > always achieve what it aims, as printk_late_init() runs it
> > unconditionally turns off all boot consoles. With this patch, I am able
> > to see more messages on the boot console in KVM guests than I can
> > without, when keep_bootcon is specified.
> > 
> > Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Cc: Greg KH <gregkh@suse.de>
> 
> The patch is applicable to 2.6.39.x and to 3.0.x but I'm unable to work
> out if the end-user impact is sufficiently serious to warrant
> backporting the fix into those kernels.
> 
> Please let us know you opinion on this.

Sorry for the delay in responding. I think it is appropriate for the
relevant -stable trees. However, it's more of an annoyance than a
serious bug (ideally you don't need to keep the boot console around as
console handover should be working -- I was encountering a situation
where the console handover wasn't working and not having the boot
console available meant I couldn't see why).

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
