Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2ILAoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 20:44:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47925 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2ILAoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 20:44:20 -0400
Date: Tue, 11 Sep 2012 17:41:25 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 08/12] tty/serial: Add kgdb_nmi driver
Message-ID: <20120912004125.GA19637@lizard>
References: <20120911093042.GA12471@lizard>
 <1347356106-25368-8-git-send-email-anton.vorontsov@linaro.org>
 <20120911151420.14a29485@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120911151420.14a29485@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 03:14:20PM +0100, Alan Cox wrote:
> > +struct kgdb_nmi_tty_priv {
> > +	struct tty_port port;
> > +	int opened;
> > +	struct tasklet_struct tlet;
> > +	STRUCT_KFIFO(char, KGDB_NMI_FIFO_SIZE) fifo;
> 
> I don't see where "opened" is used.

Yup, a leftover, with tty_port no longer needed. Thanks for noticing.

> > +static const struct tty_operations kgdb_nmi_tty_ops = {
> > +	.open		= kgdb_nmi_tty_open,
> > +	.close		= kgdb_nmi_tty_close,
> > +	.install	= kgdb_nmi_tty_install,
> > +	.cleanup	= kgdb_nmi_tty_cleanup,
> > +	.write_room	= kgdb_nmi_tty_write_room,
> > +	.write		= kgdb_nmi_tty_write,
> 
> And a hangup method (just using tty_port helpers will do the job - it's
> needed so vhangup() works as expected on a port)

Will add. Thanks a lot!
