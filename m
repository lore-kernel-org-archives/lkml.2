Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1DLGUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:20:32 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:38982 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1DLGUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:20:31 -0400
Date: Tue, 12 Apr 2011 08:08:13 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: linux-kernel@vger.kernel.org,
        Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC] NFC subsystem prototype
Message-ID: <20110412060813.GS9690@prithivi.gnumonks.org>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
 <20110409130945.GC3248@prithivi.gnumonks.org>
 <BANLkTinTXNby_zc7yz29hAdRmNK3rRht9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinTXNby_zc7yz29hAdRmNK3rRht9A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lauro,

On Mon, Apr 11, 2011 at 08:31:11PM -0300, Lauro Ramos Venancio wrote:
 
> 2011/4/9 Harald Welte <laforge@gnumonks.org>:
>
> > 0) why not create a general RFID subsystem instead of locking it down to
> >   NFC?  NFC is sort-of a superset of ISO 14443, so it would make more
> >   sense to have a generic framework that can support not only Mifare + NFC
> >   but all types of ISO 14443 (A / B) as well as ISO 15693.  This would mean
> >   other applications like electronic ID cards and ICAO-compliant passports
> >   would fit into the picture - even though not being NFC
> 
> The prototype supports ISO 14443 (A/B), MIFARE, Felica and Jewel. It's
> straightforward to add ISO 15693 support. So I think it is possible to
> support these applications using the NFC subsystem.

Then I suggest renaming the system.  I think it is a bit confusing to call
something NFC if in fact it is a way more generic RFID system for most common
13.56MHz based systems.

In other words: NFC depends on ISO 14443, but ISO 14443 does not depend on NFC,
so it would be a bit unconventional or unintuitive to use a NFC subsystem to
talk with non-NFC ISO 14443 cards/transponders.

Also, I'm not quite clear what's the situation with regard to the NFC trademark,
i.e. if it wise to use the trademark.  There has been one previous case with
the 'firewire' situation, where firewire is the trademark and IEEE 1394 the name
of the technical specification - and the the Linux subsystem is alled
'ieee1394'...

> > 1) do you really think a kernel subsystem is the best idea for this?
> >   normally, the RFID/NFC ASIC is attached either to USB or serial lines,
> >   and there are no timing constraints against userspace drivers using libusb,
> >   like the existing libnfc or librfid.
> 
> The advantages appear when you consider the NFC peer-to-peer use case
> (LLCP). A socket interface for LLCP would fit better for implementing
> some features, such as OBEX over LLCP and IP over LLCP.

Ok, I fully agree for the case of OBEX and IP.  This did not occur to me when I
made my earlier comment.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
