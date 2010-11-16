Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab0KPXFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 18:05:43 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48588 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759357Ab0KPXFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 18:05:41 -0500
Date: Tue, 16 Nov 2010 23:04:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116230430.6ccbc48c@lxorguk.ukuu.org.uk>
In-Reply-To: <20101116225834.GA27594@tango.0pointer.de>
References: <1289922400.1253.3.camel@yio.site>
	<20101116155717.6671e484@lxorguk.ukuu.org.uk>
	<AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<AANLkTinXy3pNhwqo5aqHrH9fN99JhJrBtnbbpnq2h_K-@mail.gmail.com>
	<20101116204906.29d840e9@lxorguk.ukuu.org.uk>
	<20101116214250.GB17824@tango.0pointer.de>
	<20101116225138.4e09f4dc@lxorguk.ukuu.org.uk>
	<20101116225834.GA27594@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And as long as we have no problem with letting everybody know who is
> logged in, and on which tty we shouldn't waste brain cells on discussing
> whether it is a problem if they also find out whether that login is
> currently active or not.

Thge current kernel supports you not knowing who is using which console,
furthermore there are environments where this is both used and the
current console is *very* important information.

The fact you lack the knowledge of such environments or even the wit to
figure them out doesn't mean they don't exist.
 
> Also, sysfs supports perms just fine. If you don't want people to see
> it, then just chmod 600 the sysfs file, and nobody can see it
> anymore. That's a trivial thing to do. It's a lot more difficult to hide
> who's logged in, since the user who is logged in takes possession of the
> tty file which everybody can see and stat(), even if not open().

Then it needs to start 0600 - security starts by failing safe.

> This is really a pointless discussion. Security is not an issue
> here. Which tty is currently active is completely boring information,
> and the least we should think about. 

Wrong. That's the kind of sloppy attitude that causes bugs, poor code and
security holes. It's the kind of arrogant "it only gets used like I say
it does so screw the rest of you" attitude that the certain desktops are
wrecked by.

So we *are* going to discuss the security, we are going to discuss the
permissions and we are going to discuss the permissions management model
you are trying to implement because when we've done that there is a good
chance of finding a model that a) works b) is secure and c) solves your
specific problem case.

Alan
