Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0CXVDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:03:47 -0400
Received: from web94903.mail.in2.yahoo.com ([203.104.17.144]:36666 "HELO
	web94903.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752045Ab0CXVDp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:03:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pOf4RYWQJ6qErcBMfFsJya5ltZ62HBL6jh/qqc1xBdO95S3N4apd1NUkdcvt1LFcnp9V6W1tkVxlbaLRM7M9J5Apzrc1xxSTdTV7z7CJQlF99qLsNi5Fti/lCVpZp+vLpGpkFuhJFyNEkLnqRSPrgtN+84ISeVR8lGMDJtVp2xI=;
Message-ID: <601428.86363.qm@web94903.mail.in2.yahoo.com>
X-YMail-OSG: len1kCgVM1kBGCwk7lnmWyVTWJ8Bu5vSBagzcoxE28wU_NF
 FpcI7WHGN9FTbwu7nnmuzJXmytsxdA34XilWj7zydvU2PP1nl6zNhxrISVeO
 CgMTyMi3XiReStvuCMJdS6s3LqtszqryUtfGTYV9UPzjIoaq5XH7XCLMfYUa
 arPNuZ3jHnd2YL2M6BmXyEEBFN.4Pv9d6FbzfCwbInIVKGEHSJ17AHqIkmcC
 EVexwlLd3zaPLscXzwM8RdfCl11XQ1l9nIpGdQb4DmgqwLHLv.y34I5abyuI
 tsElV9wN_UNr5VGgR1gEpD1A-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 25 Mar 2010 02:33:42 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1269464044.11714.135.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel,

--- On Thu, 25/3/10, Marcel Holtmann <marcel@holtmann.org> wrote:

> From: Marcel Holtmann <marcel@holtmann.org>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Thursday, 25 March, 2010, 2:24 AM
> Hi Pavan,
> 
> > > > Which puts me back to square 1,
> > > the requirement is TTY device should be open,
> only when
> > > either BT, FM or GPS would want to use it.
> > > > [with your patch one of the steps of
> installing ldisc
> > > would be reduced upon opening].
> > > 
> > > Perhaps but its up to you how you write your low
> level
> > > driver and how the
> > > ldisc indicates it wishes to be active (eg speed
> B0 is used
> > > to indicate
> > > 'no carrier' in many cases)
> > > 
> > > > Actually why do I even need a TTY device in
> this case
> > > - right ?
> > > > ldisc driver can do the
> tty->ops->write and
> > > tty_read and put it up on different interfaces
> like
> > > eth0/hci0 or /dev/radio0 etc..
> > > 
> > > You don't need a tty if you are simply demuxing
> some kind
> > > of stream of
> > > bytes to/from the hardware and you gain nothing
> from the
> > > tty layer and
> > > user space interfaces such as control signal and
> speed
> > > setting.
> > > 
> > 
> > I still want to maintain this as a ldisc driver and
> the TTY layer is still required to be able to use this with
> different sort of serial drivers.
> > 
> > example:
> > We do a have a system here where both 8250/omap-serial
> co-exist creating their own device nodes (ttyS for 8250,
> ttyO for omap-serial) and I would want to be able to on boot
> suggest which serial driver to use, so I can open/install
> ldisc on ttyS or on ttyO.
> > 
> > 
> > > That may be even cleaner in your case as you can
> then then
> > > provide
> > > suitable links between your demux and the drivers
> attached
> > > to it
> > > indicating when they should be on or off.
> > 
> > And as Marcel suggested, can't really put in the
> PM/UART-clk shut off code in ldisc driver because few of
> these driver provide interfaces and few don't.
> > 
> > So is there no way this can be accepted with the sysfs
> entry way of communication ?
> 
> to be quite honest, I can't see how that can be accepted
> right now. It
> looks wrong on too many levels.

Sigh -
So to save power, and open/install tty-ldisc only when required, the sysfs entry was introduced.
So now I guess I have 2 options :-

1. Fix the UART/LDISC upon boot by the daemon, get away with the sysfs entry + signaling altogether.
2. find a better way of telling the user-space daemon to open/install the line discipline.

- So any suggestions on option 2 ? like some event mechanism which is simple and clean ?

While we are at it, I will send across the BT driver too which makes use of this LDISC.

> 
> Regards
> 
> Marcel
> 
> 
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
