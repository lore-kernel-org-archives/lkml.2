Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab1HHQyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:54:37 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:48953 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab1HHQyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:54:36 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=I7fHHdvOj7QA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=azj6Gt-4AAAA:8 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=VwQbUJbxAAAA:8 a=S1bmcGEOyt7uxq_W5D8A:9 a=BV9e4L_vBqi1jPXQmI8A:7 a=CjuIK1q_8ugA:10 a=eJ1lpvm07AkA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'George Spelvin'" <linux@horizon.com>, <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>
References: <OF53580ACE.F420CB68-ONC12578E6.0039189A-C12578E6.0039CD0F@transmode.se> <20110808105201.25396.qmail@science.horizon.com>
In-Reply-To: <20110808105201.25396.qmail@science.horizon.com>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Date: Mon, 8 Aug 2011 11:54:34 -0500
Message-ID: <002a01cc55eb$da2f9a10$8e8ece30$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQE27+nmdQWDUo42aQ+pvrkutRkhKpY99xYw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: George Spelvin [mailto:linux@horizon.com]
> Sent: Monday, August 08, 2011 5:52 AM
> To: joakim.tjernlund@transmode.se; linux@horizon.com
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com; linux-
> kernel@vger.kernel.org; rpearson@systemfabricworks.com
> Subject: Re: [PATCH] add slice by 8 algorithm to crc32.c
> 
> > I prefer to keep the current code which (at the time) generated good
code
> > for at least ppc:
> > 	/* Align it */
> > 	if (unlikely((long)buf & 3 && len)) {
> > 		do {
> > 			DO_CRC(*buf++);
> > 		} while ((--len) && ((long)buf)&3);
> > 	}
> 
> Ah, I was looking at fzago's initial patch; I hadn't realized you'd
> tweaked it.  That's pretty much what I was talking about.

Frank actually deserves none of the 'blame' for this effort. He is much more
experienced in sending in patches to linux-kernel than I am and helped me to
prepare and send the first version of the patch.

> 
> Would
>  	if (unlikely((long)buf & 3) && len) {
> 
> give the compiler better hints?  len != 0 is awfully
> likely, actually.

