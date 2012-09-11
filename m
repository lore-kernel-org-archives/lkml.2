Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab2IKOKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:10:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53426 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2IKOKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:10:31 -0400
Date: Tue, 11 Sep 2012 15:14:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 08/12] tty/serial: Add kgdb_nmi driver
Message-ID: <20120911151420.14a29485@pyramind.ukuu.org.uk>
In-Reply-To: <1347356106-25368-8-git-send-email-anton.vorontsov@linaro.org>
References: <20120911093042.GA12471@lizard>
	<1347356106-25368-8-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct kgdb_nmi_tty_priv {
> +	struct tty_port port;
> +	int opened;
> +	struct tasklet_struct tlet;
> +	STRUCT_KFIFO(char, KGDB_NMI_FIFO_SIZE) fifo;

I don't see where "opened" is used.


> +static const struct tty_operations kgdb_nmi_tty_ops = {
> +	.open		= kgdb_nmi_tty_open,
> +	.close		= kgdb_nmi_tty_close,
> +	.install	= kgdb_nmi_tty_install,
> +	.cleanup	= kgdb_nmi_tty_cleanup,
> +	.write_room	= kgdb_nmi_tty_write_room,
> +	.write		= kgdb_nmi_tty_write,

And a hangup method (just using tty_port helpers will do the job - it's
needed so vhangup() works as expected on a port)


Alan
