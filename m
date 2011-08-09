Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1HISwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:52:36 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:39744 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab1HISwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:52:35 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=_Vs4JnOmORAA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=VwQbUJbxAAAA:8 a=68eEZQRoAAAA:8 a=azj6Gt-4AAAA:8 a=IuEUi4aQjoqH0N5WOacA:9 a=r-UhdREFDPBmZV-uqjYA:7 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=7YLhZ6jOsBkA:10 a=eJ1lpvm07AkA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        "'George Spelvin'" <linux@horizon.com>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>, <rdunlap@xenotime.net>
References: <4E40CCCF.5070000@systemfabricworks.com> <20110809114504.6140.qmail@science.horizon.com> <OF2A1D4C02.965787E8-ONC12578E7.005C021E-C12578E7.005C7904@transmode.se>
In-Reply-To: <OF2A1D4C02.965787E8-ONC12578E7.005C021E-C12578E7.005C7904@transmode.se>
Subject: RE: [patch v4 1/7] crc32: move-to-documentation.diff
Date: Tue, 9 Aug 2011 13:52:33 -0500
Message-ID: <016e01cc56c5$800662f0$801328d0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJabRQfxXM+gSqso4JdrKcJlf7P5wIApd4OAe6fAaOT2TaZwA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se]
> Sent: Tuesday, August 09, 2011 11:50 AM
> To: George Spelvin
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com; linux-
> kernel@vger.kernel.org; rdunlap@xenotime.net;
> rpearson@systemfabricworks.com
> Subject: Re: [patch v4 1/7] crc32: move-to-documentation.diff
> 
> "George Spelvin" <linux@horizon.com> wrote on 2011/08/09 13:45:04:
> >
> > Here's a hopefully-improved Documentation file, which explains the
slicing
> > algorithm as well.  As long as you have a big diff, it seems worth
tweaking.
> >
> > You also might want to leave a pointer in lib/crc32.c to the relocated
docs.
> >
> > (I'm just inclding the whole changed file because I assume it's easier
> > to review that way; do you prefer a diff?)
> 
> Nice, reading this once again I think I found an old typo. See below
> 
> Perhaps Bob can add this addition to his patch series?
> 
> >
> > === Cut here ===
> ...
> > Or in little-endian:
> > for (i = 0; i < input_bytes; i++) {
> >    remainder ^= next_input_byte();
> >    for (j = 0; j < 8; j++) {
> >       multiple = (remainder & 1) ? CRCPOLY : 0;
> >       remainder = (remainder << 1) ^ multiple;
> 
> Should not above line be:
>        remainder = (remainder >> 1) ^ multiple;

I agree. Will change in text.

> ?
> 
> >    }
> > }
> >
> > If the input is a multiple of 32 bits, you can even XOR in a 32-bit
> > word at a time and increase the inner loop count to 32.

