Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1BRVQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:16:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48450 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab1BRVP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:15:59 -0500
Date: Fri, 18 Feb 2011 22:15:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86: Combine printk()s in show_regs_common()
Message-ID: <20110218211551.GA7494@elte.hu>
References: <4D5D535A0200007800032730@vpn.id2.novell.com>
 <tip-fd8fa4d3ddc4cc04ec8097e632b995d535c52beb@git.kernel.org>
 <1298058105.15565.4.camel@Joe-Laptop>
 <20110218200528.GA4966@elte.hu>
 <1298060386.15565.25.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298060386.15565.25.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Fri, 2011-02-18 at 21:05 +0100, Ingo Molnar wrote:
> > * Joe Perches <joe@perches.com> wrote:
> > > Ingo, why did you choose to apply this patch instead of
> > > the alternative one I posted on the same thread?
> > Your version:
> > 
> > 	/* Board Name is optional */
> > 	board = dmi_get_system_info(DMI_BOARD_NAME);
> > 	if (!board)
> > 		board = "";
> > 
> > 	printk(KERN_CONT "\n");
> > 
> > 	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
> > 	       current->pid, current->comm, print_tainted(),
> > 	       init_utsname()->release,
> > 	       (int)strcspn(init_utsname()->version, " "),
> > 	       init_utsname()->version,
> > 	       vendor, product,
> > 	       strlen(board) ? "/" : "",
> > 	       board);
> > 
> > The 'board' fiddling and the strlen(board) check complicates things unnecessarily 
> > and makes the code hard to read. Jan's version was at least simple.
> 
> Perhaps you should look at the surrounding code.
> It's uses the same style as I chose for "board".

Yes, i realize that, but the strlen() trick really looks weird.

And 'weird' is not something i like seeing in essential bug reporting code.

Thanks,

	Ingo
