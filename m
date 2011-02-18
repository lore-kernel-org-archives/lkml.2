Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab1BRUTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:19:50 -0500
Received: from mail.perches.com ([173.55.12.10]:3751 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1BRUTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:19:49 -0500
Subject: Re: [tip:x86/debug] x86: Combine printk()s in show_regs_common()
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110218200528.GA4966@elte.hu>
References: <4D5D535A0200007800032730@vpn.id2.novell.com>
	 <tip-fd8fa4d3ddc4cc04ec8097e632b995d535c52beb@git.kernel.org>
	 <1298058105.15565.4.camel@Joe-Laptop>  <20110218200528.GA4966@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:19:46 -0800
Message-ID: <1298060386.15565.25.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 21:05 +0100, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> > Ingo, why did you choose to apply this patch instead of
> > the alternative one I posted on the same thread?
> Your version:
> 
> 	/* Board Name is optional */
> 	board = dmi_get_system_info(DMI_BOARD_NAME);
> 	if (!board)
> 		board = "";
> 
> 	printk(KERN_CONT "\n");
> 
> 	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s%s%s\n",
> 	       current->pid, current->comm, print_tainted(),
> 	       init_utsname()->release,
> 	       (int)strcspn(init_utsname()->version, " "),
> 	       init_utsname()->version,
> 	       vendor, product,
> 	       strlen(board) ? "/" : "",
> 	       board);
> 
> The 'board' fiddling and the strlen(board) check complicates things unnecessarily 
> and makes the code hard to read. Jan's version was at least simple.

Perhaps you should look at the surrounding code.
It's uses the same style as I chose for "board".

void show_regs_common(void)
{
	const char *vendor, *product, *board;

	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
	if (!vendor)
		vendor = "";
	product = dmi_get_system_info(DMI_PRODUCT_NAME);
	if (!product)
		product = "";
...

> Something like this:
> 
> 	/* Board Name is optional */
> 	board = dmi_get_system_info(DMI_BOARD_NAME);
> 
> 	printk(KERN_CONT "\n");
> 
> 	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s %s %s %s\n",
> 	       current->pid, current->comm, print_tainted(),
> 	       init_utsname()->release,
> 	       (int)strcspn(init_utsname()->version, " "),
> 	       init_utsname()->version,
> 	       vendor, product, board ? : "");
> 
> Would be easier to read and gives similarly useful output.

It's a question of using identical output or
merely similar output.

cheers, Joe

