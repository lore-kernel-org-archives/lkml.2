Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0CXRc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:32:57 -0400
Received: from web94901.mail.in2.yahoo.com ([203.104.17.136]:38829 "HELO
	web94901.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932322Ab0CXRcy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:32:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=h6vFObYwkHZxCGyXpiE5jLnhb9/bhyJ/GWG/OPeLTwiWUzkrQ1pUt16HO5pj7CcbmwSniNnLUT3JzPZrb8wMnTgrcJEbAX9cAgXHOulqovO9Ly8xml1mixDWOrbZ8OM1ks8aSQCtZVU3inzwCV3r2pfG7l6Gj78vEqqfEe/78Jk=;
Message-ID: <669779.38970.qm@web94901.mail.in2.yahoo.com>
X-YMail-OSG: 8lTw2aEVM1ng33ot9pKBoC.s5H85D3QT7IkyWE_6ThbKd8a
 N9.QKnrbCiZ0OYNvwsuVGUN279BEpxFkm5.eie9YQiC4jh1KpPpB2jcVKd0t
 1w9W8UKrKf1IzcnJ7cewy6rRT1ft99o7MmPkB8YAgKyj4tnlHn08cIQWPMM_
 hg26tLGKzpwB38mp3q_O4QHr7PR5OlmqL5FhBppRL7IX12gDfwd1FHJ5FmZ1
 M5YJGsupVKv7pHfd4HsJpq1bicbvTaGTd8JamucN0jihiitHFvfc529iCQfr
 uIPR3LsBjmyNJybXtxpXlx3s-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 23:02:51 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100324172647.572e3cb8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 10:56 PM
> > Isn't there a mechanism for the
> tty_set_ldisc to do what _open does ?
> > I mean there might be plenty of devices on UART which
> might not need /dev/tty at all ? i.e An App need not open
> for a ldisc to be installed.
> 
> There is no mechanism to have an open tty without having an
> open file
> attached to it - and changing that would be very very non
> trivial. Plus
> you still need a way to tell the kernel you want the device
> in question
> active. That probably should get addressed some day but its
> not a quick
> fix up!

Which puts me back to square 1, the requirement is TTY device should be open, only when either BT, FM or GPS would want to use it.
[with your patch one of the steps of installing ldisc would be reduced upon opening].

Now from kernel-space which is the first to get notification about requirement of BT/FM or GPS, I somehow have to communicate it to user-space, without the much disliked sysfs entry method.

How do I tell the user-space when I want the TTY device to be opened ?
Actually why do I even need a TTY device in this case - right ?
ldisc driver can do the tty->ops->write and tty_read and put it up on different interfaces like eth0/hci0 or /dev/radio0 etc..

That would mean, a device can be on UART, a ldisc driver attached to it, and doesn't require a user-space daemon to maintain the device node.

> 
> Alan
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
