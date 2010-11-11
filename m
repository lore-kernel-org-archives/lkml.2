Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0KKRH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:07:56 -0500
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:39226 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754152Ab0KKRHz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:07:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=sJG2GwRLYlN4doTvnCq2sxi6PC1ir1BGFArSyq/aitjg6+HUZwS4vtr8+KWwx5nPSEb/1Zn5n1hY4nWF5ZDIrnnjhfwtmufICU4ngE4/g9CGcQMZpwNgVY+gWiA8p73M4UjG+HOzPNzvtHBybzgYTyKQTZD/GQR1Mjwjw0WFjMQ=;
Message-ID: <151524.65160.qm@web31809.mail.mud.yahoo.com>
X-YMail-OSG: 8qGNEcEVM1lI_mqxzIWP4kDIVyF4yvcASVkEDsdUhA9eS4H
 PiLIUBI.0F4hPE8VsE6PEzCVNGoC8r0mei4z2rAzhNnIDyGxibxlAsEC10El
 5Nmu14lcErMOVKAQ74mUebzJSjS9vYxV4JwjNNvWki2bmO.XcmCDRiMeVzra
 hBwr.IBP49DG.r3tQRPiN4CnPbGrrfzSUkPbTeRMA8i4KhcR8cEcie8CWTuk
 qzu2.vcAFmjIdKke7SOh52tBcQmtnmQUdIX0aHo1Ip3jnWFPR8STukXx8ubs
 wHHh.IN7.bTNyGNzZK5Mpijp7usmiNsGUhSlvLBuZ0z.qER3otCogqVy41zC
 jpHw2SoUTJlWnKykCNrm8wlROD_LteeBVSg--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 11 Nov 2010 09:07:53 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
In-Reply-To: <20101111165717.GA8526@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 11/11/10, Greg KH <greg@kroah.com> wrote:
> On Thu, Nov 11, 2010 at 08:49:51AM
> -0800, Luben Tuikov wrote:
> > --- On Thu, 11/11/10, Greg KH <greg@kroah.com>
> wrote:
> > > On Fri, Oct 22, 2010 at 02:12:51PM
> > > -0700, Luben Tuikov wrote:
> > > > This patch solves two things:
> > > > 1) Enables autosense emulation code to
> correctly
> > > > interpret descriptor format sense data, and
> > > > 2) Fixes a bug whereby the autosense
> emulation
> > > > code would overwrite descriptor format sense
> data
> > > > with SENSE KEY HARDWARE ERROR in fixed
> format, to
> > > > incorrectly look like this:
> > > > 
> > > > Oct 21 14:11:07 localhost kernel: sd
> 7:0:0:0:
> > > [sdc]? Sense Key : Recovered Error [current]
> > > [descriptor]
> > > > Oct 21 14:11:07 localhost kernel: Descriptor
> sense
> > > data with sense descriptors (in hex):
> > > > Oct 21 14:11:07 localhost kernel:? ? ?
> > > ? 72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00
> 00
> > > > Oct 21 14:11:07 localhost kernel:? ? ?
> > > ? 00 4f 00 c2 00 50
> > > > Oct 21 14:11:07 localhost kernel: sd
> 7:0:0:0:
> > > [sdc]? ASC=0x4 ASCQ=0x1d
> > > > 
> > > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > > 
> > > I need to get the ack from the usb-storage
> > > maintainer.? Can you get that
> > > so that I can apply this?
> > 
> > Hi Greg,
> > 
> > I don't know who the usb-storage maintainer is, as
> I've mostly
> > contributed to linux-scsi. Do you?
> 
> $ ./scripts/get_maintainer.pl --roles --file
> drivers/usb/storage/usb.c
> Matthew Dharm <mdharm-usb@one-eyed-alien.net>
> (maintainer:USB MASS STORAGE...)
> Greg Kroah-Hartman <gregkh@suse.de>
> (supporter:USB SUBSYSTEM)
> linux-usb@vger.kernel.org
> (open list:USB MASS STORAGE...)
> usb-storage@lists.one-eyed-alien.net
> (open list:USB MASS STORAGE...)
> linux-kernel@vger.kernel.org
> (open list)
> 
> Or you can just look in the MAINTAINERS file :)

Oh, and I was looking for the MAINTAINERS file in Documentation/.

Wow! There is actually a "get_maintainer" script!? Unbelievable!

> > I know Alan acked this patch. Is it him? Any reason
> you didn't CC the
> > usb-storage maintainer in this email?  Can you
> reply back to this
> > thread CC-ing him? The only email I have in my address
> book is yours.
> 
> Please resend your patch to Matthew, and the people and
> lists listed
> above.  I need his ack before I can take it.

Oh, I see. I'll re-post the patch then to Matthew and the people and lists you listed above.

