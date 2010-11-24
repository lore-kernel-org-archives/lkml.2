Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0KXSsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:48:33 -0500
Received: from sg2ehsobe001.messaging.microsoft.com ([207.46.51.75]:29118 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750838Ab0KXSsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:48:31 -0500
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Nov 2010 13:48:31 EST
X-SpamScore: -36
X-BigFish: VPS-36(zzbb2dK542N1432N98dN14ffO9371Pzz1202hzz8275dhz2dh95h691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: RE: Mega rename of device tree routines from of_*() to dt_*()
Date: Wed, 24 Nov 2010 10:32:11 -0800
In-Reply-To: <4CED48CE.5060300@caviumnetworks.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Mega rename of device tree routines from of_*() to dt_*()
Thread-Index: AcuL+5MExKaPVux0RsiMeMP0dz+DbQACj7rQ
References: <1290607413.12457.44.camel@concordia> <fa44e045-9600-4c46-939a-af246afab4f6@VA3EHSMHS019.ehs.local> <4CED48CE.5060300@caviumnetworks.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: David Daney <ddaney@caviumnetworks.com>
CC: <michael@ellerman.id.au>, LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        <microblaze-uclinux@itee.uq.edu.au>,
        <devicetree-discuss@lists.ozlabs.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 24 Nov 2010 18:33:14.0966 (UTC) FILETIME=[0E693760:01CB8C06]
X-RCIS-Action: ALLOW
Message-ID: <ee487d0b-ec9d-42a9-9c8e-39f83858cffc@SG2EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAOImhnE014233



> -----Original Message-----
> From: David Daney [mailto:ddaney@caviumnetworks.com]
> Sent: Wednesday, November 24, 2010 9:18 AM
> To: Stephen Neuendorffer
> Cc: michael@ellerman.id.au; LKML; linux-mips; microblaze-uclinux@itee.uq.edu.au; devicetree-
> discuss@lists.ozlabs.org; linuxppc-dev list; sparclinux@vger.kernel.org
> Subject: Re: Mega rename of device tree routines from of_*() to dt_*()
> 
> On 11/24/2010 09:02 AM, Stephen Neuendorffer wrote:
> >
> >
> >> -----Original Message-----
> >> From: linuxppc-dev-bounces+stephen=neuendorffer.name@lists.ozlabs.org [mailto:linuxppc-dev-
> >> bounces+stephen=neuendorffer.name@lists.ozlabs.org] On Behalf Of Michael Ellerman
> >> Sent: Wednesday, November 24, 2010 6:04 AM
> >> To: LKML
> >> Cc: linux-mips; microblaze-uclinux@itee.uq.edu.au; devicetree-discuss@lists.ozlabs.org; linuxppc-
> dev
> >> list; sparclinux@vger.kernel.org
> >> Subject: RFC: Mega rename of device tree routines from of_*() to dt_*()
> >>
> >> Hi all,
> >>
> >> There were some murmurings on IRC last week about renaming the of_*()
> >> routines. I was procrastinating at the time and said I'd have a look at
> >> it, so here I am.
> >>
> >> The thinking is that on many platforms that use the of_() routines
> >> OpenFirmware is not involved at all, this is true even on many powerpc
> >> platforms. Also for folks who don't know the OpenFirmware connection it
> >> reads as "of", as in "a can of worms".
> >>
> >> Personally I'm a bit ambivalent about it, the OF name is a bit wrong so
> >> it would be nice to get rid of, but it's a lot of churn.
> >>
> >> So I'm hoping people with either say "YES this is a great idea", or "NO
> >> this is stupid".
> >
> > Personally, I think it's a great idea, if only because I stared long and hard
> > at the code once upon a time trying to figure out what is really OF-related
> > and what isn't.  It's somewhat clearer now that drivers/of has been factored
> > out (although, shouldn't it be drivers/dt???)
> >
> > That said, it *is* alot of code churn.  If it's going to be done, I think it should be
> > done in concert with fixing a bunch of the function names which don't really follow any
> > sane naming convention, so that the backporting discontinuity only happens once.
> >
> 
> Oh, you mean things like:
> 
> of_{,un}register_platform_driver vs. platform_driver_{,un}register
> 
> That one is particularly annoying to me.
> 
> David Daney

Actually, I was particularly thinking of drivers/of/fdt.c, which I was recently hacking around with,
but I'm sure there are others... :)

Steve

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
