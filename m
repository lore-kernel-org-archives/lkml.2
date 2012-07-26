Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2GZAGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:06:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:14337 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2GZAG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126946129"
Date: Thu, 26 Jul 2012 01:23:37 +0100
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-ID: <20120726012337.13b78bc8@bob.linux.org.uk>
In-Reply-To: <20120725224731.GA14020@kroah.com>
References: <20120720150237.af0d271624511fc18705f287@canb.auug.org.au>
	<20120725224731.GA14020@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  		if (serial->type->set_termios) {
> > -			tty->termios->c_cflag = cflag;
> > -			tty_termios_encode_baud_rate(tty->termios,
> > baud, baud);
> > +			tty->termios.c_cflag = cflag;
> > +
> > tty_termios_encode_baud_rate(&tty->termios, baud, baud);
> > memset(&dummy, 0, sizeof(struct ktermios));
> > serial->type->set_termios(tty, port, &dummy); 
> 
> Alan, any objection to this?

The fix looks correct to me.

