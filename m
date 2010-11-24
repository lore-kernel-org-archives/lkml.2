Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0KXQpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:45:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45022 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754388Ab0KXQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:45:41 -0500
Date: Wed, 24 Nov 2010 16:43:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        "Alan \"I must be out of my tree\" Cox" <alan@linux.intel.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 05/17] tty: don't allow ldisc dcd_change() after ldisc
 halt
Message-ID: <20101124164329.75368d71@lxorguk.ukuu.org.uk>
In-Reply-To: <48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
	<48e935cac42ae455e2ef8fc45f7eef7631eece6b.1290599844.git.lasaine@lvk.cs.msu.su>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010 19:15:43 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> There was a possibility that uart_handle_dcd_change() could obtain a
> reference to ldisc while running in parallel with tty_set_ldisc() on
> different CPU but call dcd_change() operation after tty_ldisc_close()
> which is incorrect.

How can this occur ?


> +	spin_lock_irqsave(&tty->dcd_change_lock, flags);
> +
> +	ld = tty_ldisc_ref(tty);

What is the expecting lock ordering rule here ?



I don't see why this patch is needed. You've got an ldisc ref from
tty_ldisc_ref, until you drop that ldisc ref you are fine. If for some
reason that is not the case then there is a bug in the ldisc code.

Alan
