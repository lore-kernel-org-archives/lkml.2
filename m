Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3AJPao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:30:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:8375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab3AJPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:30:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,444,1355126400"; 
   d="scan'208";a="189780069"
Date: Thu, 10 Jan 2013 15:50:58 +0000
From: Alan Cox <alan@linux.intel.com>
To: Florian Westphal <fw@strlen.de>
Cc: linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        gregkh@linuxfoundation.org, frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
Message-ID: <20130110155058.12f66e73@bob.linux.org.uk>
In-Reply-To: <20130110144626.GA26279@breakpoint.cc>
References: <20130110144626.GA26279@breakpoint.cc>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013 15:46:26 +0100
Florian Westphal <fw@strlen.de> wrote:

> Frank Lichtenheld discovered that openpty() doesn't work anymore when
> /dev/pts is not present.
> 
> We bisected this down to
> 
> commit bbb63c514a3464342967237a51a21ea8f61ab951
> Author: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Subject: drivers:tty:fix up ENOIOCTLCMD error handling
> 
> The original program triggering the error was pptpd, but
> the test program below is sufficient:
> ----
> #include <stdio.h>
> #include <pty.h>
> int main(void) {
>  int pty_fd, tty_fd;
>  if (openpty(&pty_fd, &tty_fd, NULL, NULL, NULL) != 0) {
>   perror("openpty");
>   return 1;
>  }
> return 0;
> }
> ----
> [ compile with cc -lutil pty.c -o pty ]
> 
> If devpts is available or above commit reverted openpty works again.

The commit is fairly general - what we need to do here is to figure out
which specific thing trips up openpty so we can put the error on that
back as it was (or find a better way) so it still works.

Can you attach an strace of the working/failing cases without /dev/pts 

Alan

