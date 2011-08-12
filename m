Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1HLRCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:02:04 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:58235 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab1HLRCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:02:01 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=wSWQpAr6UJYA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=jiHNTQD-PcK-6gWJJGEA:9 a=VYaMtrAU2taLAABixGUA:7 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <014801cc584f$5ff90e00$1feb2a00$@systemfabricworks.com> <OF79B4FA74.153E98FD-ONC12578EA.0021A784-C12578EA.0024990B@transmode.se> <026a01cc5907$d4917f50$7db47df0$@systemfabricworks.com>
In-Reply-To: <026a01cc5907$d4917f50$7db47df0$@systemfabricworks.com>
Subject: RE: [patch v5 resending 0/8] Add slicing-by-8 to crc32
Date: Fri, 12 Aug 2011 12:01:59 -0500
Message-ID: <027d01cc5911$8d388770$a7a99650$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQB1TE/iCpDUaKMDJaAWrgI6YSoYCwKURzh8AdukMhuXpAm8oA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > The changes to gen_crc32table.c looks random, where did this come from
> > (in v5 6/8):
> >  -static uint32_t crc32table_le[4][LE_TABLE_SIZE];
> > -static uint32_t crc32table_be[4][BE_TABLE_SIZE];
> > +static uint32_t crc32table_le[4][256];
> > +static uint32_t crc32table_be[4][256];
> 
> The table was declared as shown but is passed from main to output_table as
> "uint32_t table[4][256]"
> 
> This causes a compiler warning because the types don't match. As it
happens
> the program prints out correct results because rows other than 0 are only
> used of the column size is 256. I interpreted LE_TABLE_SIZE as the desired
> size of the output table (which it is) and let the working table in
> gen_crc32table.c be dimensioned at 256. I suppose that one could have
> changed the dimension in output_table as well.
> 

One more point I forgot when I wrote this. Output_table is used for both LE
and BE tables which could have different values for ?E_TABLE_SIZE. There is
no sensible choice for changing the declaration in output_table to try to
match the various table sizes. It is much simpler to just make the tables
"by 256" and leave it at that. Since this is a build time resource there is
no penalty for the kernel itself.

