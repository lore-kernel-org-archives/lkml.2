Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1HHWVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:21:36 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:44259 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab1HHWVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:21:35 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=I7fHHdvOj7QA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=VwQbUJbxAAAA:8 a=azj6Gt-4AAAA:8 a=YORvzBCaAAAA:8 a=Z4Rwk6OoAAAA:8 a=W0vUJOdyAAAA:8 a=crK7uqMkYtkbihImT64A:9 a=kkxwqrBxgHr4lVWL6BMA:7 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=eJ1lpvm07AkA:10 a=VV2__AUApEoA:10 a=jbrJJM5MRmoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'George Spelvin'" <linux@horizon.com>, <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>
References: <002b01cc55ec$db14fb90$913ef2b0$@systemfabricworks.com> <20110808204524.12911.qmail@science.horizon.com>
In-Reply-To: <20110808204524.12911.qmail@science.horizon.com>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Date: Mon, 8 Aug 2011 17:21:33 -0500
Message-ID: <00ab01cc5619$8814fdf0$983ef9d0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHLzSLgFP5a0FH1xR7vuNBKLL3fppUUlj7w
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of George Spelvin
> Sent: Monday, August 08, 2011 3:45 PM
> To: joakim.tjernlund@transmode.se; linux@horizon.com;
> rpearson@systemfabricworks.com
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
> 
> > Happy to consider this. I have been asking the list for comments about
the
> > idea of dropping the BITS=2 and BITS=4 algorithms altogether which would
> > make the table size just 256. So far no one has claimed that they
actually
> > care about those algorithms except as 'examples'. The 'Sarwate'
algorithm
> > (which I added as an 8 bit version) is faster and only adds 2x4KB of
table.
> 
> Um, I thought the Sarwate agorithm was what was already there as BITS=8.
> (The original paper stores the CRC in two 8-bit variables and two
> 8-bit tables rather than using 16-bit words, but other than that,
> it's identical.)

In the current i.e. original version of crc32.c BITS=8 is the 32 bit
algorithm. The Sarwate version is not used. In the patched version that was
moved to BITS=32 and another one slipped in as BITS=8 which is Sarwate.

> 
> And that requires just 1KB of table per endianness.

You're right! Its 2X1KB not 2X4KB. There are 2 tables (le and be).

> 
> Anyway, I thought the complaint about laarge tables was
> not so much the memory as the L1 cache pollution. 

As far as performance goes cache pollution is the more important effect.
That is why you can't just extend the 2, 4, 8 sequence which has the tables
growing exponentially with BITS. The Slicing-by-N algorithm though has table
size growing linearly with N. But, if you are trying to run Linux on a small
embedded CPU even linear table size might be important. Back in the good old
days you could strip Linux down to a very small kernel.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

