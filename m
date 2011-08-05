Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab1HEPvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:51:08 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:34264 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552Ab1HEPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:51:03 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=I7fHHdvOj7QA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=E3JUflbP-Z-PLmnorkwA:9 a=_y-yNVsX3OwVeKDXip8A:7 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'frank zago'" <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>
References: <OF4AE0115F.3AA5397E-ONC12578DF.002EC6DF-C12578DF.003348E5@transmode.se> <01dc01cc5159$317879a0$94696ce0$@systemfabricworks.com> <OF83CC7C9C.07EC5D4A-ONC12578E2.0024F5AE-C12578E2.004163C1@transmode.se> <019501cc52d7$c8688100$59398300$@systemfabricworks.com> <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@transmode.se>
In-Reply-To: <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@transmode.se>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Date: Fri, 5 Aug 2011 10:51:00 -0500
Message-ID: <023b01cc5387$79b09dd0$6d11d970$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AQDVh4pDc04B6RwbKPhJsZYe9rqqGgID1lG1AfPbjtABsy4QAgGPPXDLlsIrZTA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > version. While I haven't done the experiment you suggest there is
> something
> > to the point that the second q computation in the new version can be
> moved
> > ahead of the table lookups from the first q computation . My guess is
that
> > the unrolled version will be significantly slower.
> 
> Ah, didn't see that. Don't understand how this works though.
> Why do you do two 32 bit loads instead of one 64 bit load?
> 
> >

The two expression trees can be computed in parallel and combined with the
final xor. If the compiler/instruction scheduler are smart enough and can
process enough instructions per cycle they overlap well and you get some
speedup. I did try a 64 bit load on Nehalem but got about 2 cycles per byte
which is a little worse than doing two loads and better than the 32 bit
version. I'm not really sure why.

