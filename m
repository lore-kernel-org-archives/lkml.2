Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1D0NVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:21:41 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:60922 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732Ab1D0NVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:21:38 -0400
Date: Wed, 27 Apr 2011 13:21:36 +0000 (UTC)
From: johnlinn@comcast.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        michal simek <michal.simek@petalogix.com>, joe@perches.com,
        grant likely <grant.likely@secretlab.ca>, greg@kroah.com
Message-ID: <126598808.1934339.1303910496698.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <20110427103340.2554df83@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH V3] tty/serial: add support for Xilinx PS UART
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:

> > I thought I was improving but now as I look at it further, that
> seems like it 
> > was better and I should have stuck to that method.
> > 
> > Thoughts?
> 
> Go for nearest is the right behaviour. The whole tty layer works on
> that
> basis as do soem other things. It means you don't have to have a set
> of
> calls to do things like "enumerate valid data rates" instead you ask
> and
> compare.

I wasn't very clear on that, sorry about that.

I meant we were not detecting if the error was too much and finding the 
nearest baud rate that had an acceptable amount of error. 

We were just finding the best baud rate generator values for the baud and
then using them without any kind of error.

Thanks,
John

> 
> > > > +	uart_update_timeout(port, termios->c_cflag, baud);
> > > 
> > > [which would also fix this timeout!]
> > 
> > Maybe you were meaning that if the baud rate was not really set
> because of the
> > error this timeout would be wrong also, and if so that makes sense.
> 
> Correct
> 
> Alan
