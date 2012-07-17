Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2GQKH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:07:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36937 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2GQKHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:07:24 -0400
Date: Tue, 17 Jul 2012 11:10:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120717111053.287191b3@pyramind.ukuu.org.uk>
In-Reply-To: <20120717134506.3f3f0614ad1d5193689de334@canb.auug.org.au>
References: <20120717134506.3f3f0614ad1d5193689de334@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 13:45:06 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/tty/tty_ioctl.c: In function 'set_sgflags':
> drivers/tty/tty_ioctl.c:741:9: error: request for member 'c_iflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:742:9: error: request for member 'c_oflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:743:9: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:745:10: error: request for member 'c_iflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:746:10: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:749:10: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:753:10: error: request for member 'c_oflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:756:10: error: request for member 'c_iflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:757:10: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:759:15: error: request for member 'c_lflag' in something not a structure or union
> drivers/tty/tty_ioctl.c:760:10: error: request for member 'c_cc' in something not a structure or union
> drivers/tty/tty_ioctl.c:761:10: error: request for member 'c_cc' in something not a structure or union
> 
> Caused by commit adc8d746caa6 ("tty: move the termios object into the
> tty").  Did anyone build test this?  :-(

It's known not to build. I sent Greg some patches but he wants them
versus a different tree. I hope to have that done and tested in the next
couple of days, until then I'd suggest you drop the tty tree - in
particular because the version you are currently using scribbles on other
bits of of memory.

Alan
