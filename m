Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1HHREJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:04:09 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:53024 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab1HHREH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:04:07 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=I7fHHdvOj7QA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=VwQbUJbxAAAA:8 a=azj6Gt-4AAAA:8 a=u7nYxvMiY8R-AqDTvbQA:9 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=eJ1lpvm07AkA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        "'George Spelvin'" <linux@horizon.com>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>
References: <OF53580ACE.F420CB68-ONC12578E6.0039189A-C12578E6.0039CD0F@transmode.se> <20110808105201.25396.qmail@science.horizon.com> <OFEA1BD2B2.B2A7F07F-ONC12578E6.003D368C-C12578E6.003D7468@transmode.se>
In-Reply-To: <OFEA1BD2B2.B2A7F07F-ONC12578E6.003D368C-C12578E6.003D7468@transmode.se>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Date: Mon, 8 Aug 2011 12:04:05 -0500
Message-ID: <002c01cc55ed$2eced9e0$8c6c8da0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJKDsw680O6b7pIeH/VmFOarr73QwE27+nmAebu6T2T/s2kEA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same for x86. The code for the pre and post cleanup loops are the same
there.

> -----Original Message-----
> From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se]
> Sent: Monday, August 08, 2011 6:11 AM
> To: George Spelvin
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com; linux-
> kernel@vger.kernel.org; rpearson@systemfabricworks.com
> Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
> 
> "George Spelvin" <linux@horizon.com> wrote on 2011/08/08 12:52:01:
> >
> > > I prefer to keep the current code which (at the time) generated good
> code
> > > for at least ppc:
> > >    /* Align it */
> > >    if (unlikely((long)buf & 3 && len)) {
> > >       do {
> > >          DO_CRC(*buf++);
> > >       } while ((--len) && ((long)buf)&3);
> > >    }
> >
> > Ah, I was looking at fzago's initial patch; I hadn't realized you'd
> > tweaked it.  That's pretty much what I was talking about.
> >
> > Would
> >     if (unlikely((long)buf & 3) && len) {
> >
> > give the compiler better hints?  len != 0 is awfully
> > likely, actually.
> 
> Doesn't matter on ppc(gcc 4.4.4). The whole while loop is moved out of
line
> in both cases and the generated asm is identical.


