Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1HLPw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:52:28 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:64502 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269Ab1HLPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:52:26 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=wSWQpAr6UJYA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=Z4Rwk6OoAAAA:8 a=YORvzBCaAAAA:8 a=azj6Gt-4AAAA:8 a=VwQbUJbxAAAA:8 a=qrcUnyhLdGWwIr3KwfAA:9 a=m37sCNmcnQgBeqMB9BEA:7 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=eJ1lpvm07AkA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <014801cc584f$5ff90e00$1feb2a00$@systemfabricworks.com> <OF79B4FA74.153E98FD-ONC12578EA.0021A784-C12578EA.0024990B@transmode.se>
In-Reply-To: <OF79B4FA74.153E98FD-ONC12578EA.0021A784-C12578EA.0024990B@transmode.se>
Subject: RE: [patch v5 resending 0/8] Add slicing-by-8 to crc32
Date: Fri, 12 Aug 2011 10:52:23 -0500
Message-ID: <026a01cc5907$d4917f50$7db47df0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQB1TE/iCpDUaKMDJaAWrgI6YSoYCwKURzh8l7LPdgA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se]
> Sent: Friday, August 12, 2011 1:40 AM
> To: Bob Pearson
> Cc: akpm@linux-foundation.org; fzago@systemfabricworks.com;
> linux@horizon.com; linux-kernel@vger.kernel.org
> Subject: Re: [patch v5 resending 0/8] Add slicing-by-8 to crc32
> 
> "Bob Pearson" <rpearson@systemfabricworks.com> wrote on 2011/08/11
> 19:52:01:
> >
> > Resending the patch series by hand. I have been having a lot of problems
> > trying to
> > Figure out how to make quilt and thunderbird play together. Please let
me
> > Know of this one is better. I have never been able to get quilt to
> > Make a mbox that my thunderbird likes but Frank has been able to do it.
> > The last time I imported a mbox into thunderbird as Unsent Messages and
> then
> > Edited each note and typed send but for some reason there was a lot of
> > breakage.
> > This time I just used the external editor to read in each patch from the
> > patches
> > Directory one a time.
> 
> I am not even going to try. After a quick look the still look broken and
> several my earlier remarks appears to be ignored.

I tried to apply the patches that you mentioned did not work to a fresh tree
and they were OK.

I will go through your emails again. I thought I had caught everything.
Since I went back to passing tab[][] to one common subroutine some of the
discussion points no longer applied. The one remaining point that was often
mentioned was your preferred form for the first loop. But in the last
exchange I thought we showed that ours was shorter. I did put in the
pointers as you suggest.

> The changes to gen_crc32table.c looks random, where did this come from
> (in v5 6/8):
>  -static uint32_t crc32table_le[4][LE_TABLE_SIZE];
> -static uint32_t crc32table_be[4][BE_TABLE_SIZE];
> +static uint32_t crc32table_le[4][256];
> +static uint32_t crc32table_be[4][256];

The table was declared as shown but is passed from main to output_table as
"uint32_t table[4][256]"

This causes a compiler warning because the types don't match. As it happens
the program prints out correct results because rows other than 0 are only
used of the column size is 256. I interpreted LE_TABLE_SIZE as the desired
size of the output table (which it is) and let the working table in
gen_crc32table.c be dimensioned at 256. I suppose that one could have
changed the dimension in output_table as well.



> 
>  Jocke


