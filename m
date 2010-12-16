Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0LPJq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:46:56 -0500
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:39399 "HELO
	web31803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753910Ab0LPJqw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:46:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=l5Uluu42ceWzWl2/ezmPpDNdCc3XdXjNhvOboiTpBFnVhU/pS/u61eHatgihTe5tzRWDD3BLbsVtt8bprGC6w4JSF197INQWcMypKYCII8Fp8ZyX8584+jtaTiux0Bpf/ncORGyQeTSUPCDRyNgPan6B8xmXePj4HvbwAda73nY=;
Message-ID: <566988.16939.qm@web31803.mail.mud.yahoo.com>
X-YMail-OSG: 2HiBXrEVM1mwe0noiLrQBFCdbaSmqijBBJe7v6e3HHaMI5n
 E9narJ8lO5K_NCXh9RruPbYGkxPEt2TnAEJgnEIvItEP0HTk.zk.Rx.zdIcN
 QvuefYkApbffdg9LfmH8pzhmd256Gq.eoDxFgd2Vv0u33I9HcSkg9112uK42
 ig1BA0h8CnSPYh9.2n6kVPaOwEDH15VXHjri1msCjzIpI.q2dtTIADdFTmVa
 Hlz_NMusfeCNUE9LxeqT3zyBZ_DGygcleeh.RFI1rKZv26SRIe05EFYU7pMp
 .IkWITTfQ10tRi1ZPKo9yRQtjXH.eqSnFv4ycL0HkPZSOvX.VLbCc1WmvyNq
 4sdQntVwLJeF_DISuYsnqGThWv9Nk72iTNhW93GH7480fLj2fxGQuGUYB2B1
 1ongqksZ26Fdl
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Thu, 16 Dec 2010 01:46:50 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Ben Gamari <bgamari@gmail.com>, Andreas Mohr <andi@lisas.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20101216062953.GA7427@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 12/15/10, Andreas Mohr <andi@lisas.de> wrote:
> Hi,
> 
> I had preferred to subsequently calmly stay on the
> sidelines
> after trying to argue for a beneficial compromise,
> but given this lack of realism I'm choosing to reply
> again:
> 
> Ben Gamari wrote this:
> > This is may be true, perhaps he didn't look at the
> code. This is not
> > because he doesn't have confidence that your driver is
> well-written or
> > holds a grudge against you. The reason for this NAK is
> policy: a driver
> > already exists. In the kernel we work with what
> already exists, even if
> > it may be more difficult than the alternative.
> 
> One word: HOG-WASH. At least the e100 vs. eepro100 case is
> a clear

Andreas, the way you've cut out the quote above, it seems that you're replying to something I've written, when in fact you're replying to Ben Gamari.

Above, I've corrected the quote, not to confuse people of course.

> counter-example to that. That was an eepro100 driver which
> has been in active
> mainline service for years and had many diagnostic
> features,
> to then be replaced (one could argue that it _may_ be
> better indeed
> to replace a possibly less-maintained driver with a
> better-maintained one
> by the original hardware manufacturer).

So eepro100.c was written by Don (as was rtl8139.c) and was replaced by e100.c written by its manufacturer (same place where uas.c is coming from)? Interesting...

As I recall rtl8139.c was also replaced by 8139too.c after many years with many devices in the field, instead of "dividing the code into patches for the driver which is already in the kernel and submitting it for review". The author of 8139too.c used to submit patches to rtl8139.c (as can be seen in the source of that driver) but then decided to write his own 8139too.c and submit it and it got accepted and now that's the only driver in the kernel for that chip. The copyright comment of 8139too.c says this.

Hmm... Interesting and insightful stuff. So who are those people that can rewrite whole drivers and get theirs in and the old ones out?

> The way I see it there is this (likely incomplete) list of
> reasons to
> prefer the "old", "challenged"(?) new driver:
> . there's the "old", "timely submitted" 
>   driver, and the entire thing may be an
> understandably much-less-than-positive situation for its
> author
> . the author of the new one is a d**k to argue with
>   (may easily be true given several cases of his
> awfully "personal" arguing,
>    but in his position facing such often
> unbased opposition
>    other people might have lost some temper,
> too),
>   causing uncertainty about proper continued
> maintenance of the driver

Within the last two months, I've submitted more patches to uasp.c (4-5) than the original author to uas.c (none). As well as I've submitted patches to uas.c itself (three, first two accepted, third rejected since it changed 86% of the uas.c code), lsusb, sd.c, block/blk-tag.c, etc.

Also, uasp.c is a protocol driver.  The protocol will change a bit but not by that much.  When this happens I'll submit new patches to update it, unless someone submits them before that. Even if no patches are submitted to support latter version of the protocol, UAS devices will be backward compatible.

In effect, this driver doesn't warrant much maintenance by virtue of its nature, but support is there if need be.

> . for some certain reason, it's had "more testing", its
> situation is "better", ...

"more testing" -- do you mean uasp.c or uas.c?  If you have a UAS device, try both drivers (do I/O) and see for yourself. uas.c also doesn't support the UAS protocol by definition as it doesn't support TMF and other features present in uasp.c.

> . suddenly accepting an entirely different driver after
> another can
>   legitimately be seen as some kind of unhealthy
> disruption of the
> development advancement
> . at this point in time we've lost enough additional time
> arguing
>   that a change of drivers might now really be
> inconvenient
>   from a kernel release continuity/planning POV.
>   Let me tell you that I'm somewhat unconvinced of
> this, though.
> 
> Perhaps at this time the only thing to be said is that due
> to "policy" (yeah, whatever)
> a more timely submitted driver will remain in and the
> supposedly better
> driver will stay out, but given the history of Linux kernel
> drivers this
> is more than a bit unconvincing, as outlined above.
> Of course one could argue that this policy simply is quite
> _new_
> and didn't exist yet at the time of the other conflicts
> (e100, 8139, RAID adapters),
> and possibly has been established exactly _due_ to the many
> difficulties that turned
> up in these cases.
> However it's still questionable whether it's appropriate
> to apply such a policy _in this case_
> given that _both_ candidates aren't entrenched (in active
> service) at all.
> 
> 
> Still, I hope that even with a "negative" decision the best
> elements of the
> drivers will eventually find their way into a combined
> driver,
> with appropriate amounts of maintenance.

You make some very good points, however it's a Goliath vs. David situation but this time David loses. While this may seem similar to rtl8139.c vs. 8139too.c and eepro100.c vs. e100.c, the difference is that the backing behind 8139too.c and e100.c is with with uas.c. Working code or the quality of the code is irrelevant here.  uasp.c got rejected 4 minutes after submission.

uasp.c wouldn't even make it in the kernel alongside uas.c, to give people a choice at least. (and we've heard the excuse for that one before, while there had been two drivers for the same device in the kernel before)

In the immediate future distros may include uasp.c since it provides UAS support. Independent Linux vendors may do the same for the same reason. HDD/ASIC manufacturers may use uasp.c to test their UAS devices (an alternative to the Windows tools).

In the future though, I expect that someone will study uasp.c and submit patches to uas.c and eventually you'll see uas.c look exactly as uasp.c does now (sans the credits, similarly to what happened to the SAS code five years ago).

However, people are free to use whatever they want.

If you have a UAS device and would like to play with it, uasp.c is available on github: http://marc.info/?t=129227496000002&r=1&w=2

   Luben

