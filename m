Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1IFQFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:05:10 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:42494 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754952Ab1IFQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:05:08 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=bMtn2c2igAkA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=YORvzBCaAAAA:8 a=T2XT7cPYVX1L192au6QA:9 a=EZFyWjRDr9kdvKxIaLcA:7 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <fzago@systemfabricworks.com>,
        "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        "'George Spelvin'" <linux@horizon.com>
References: <20110831213729.395283830@systemfabricworks.com>	<4E5EB5F4.6010105@systemfabricworks.com> <20110902165047.6aaec238.akpm@linux-foundation.org>
In-Reply-To: <20110902165047.6aaec238.akpm@linux-foundation.org>
Subject: RE: [PATCH v6 05/10] crc32-misc-cleanup.diff
Date: Tue, 6 Sep 2011 11:05:06 -0500
Message-ID: <01c101cc6cae$bf219460$3d64bd20$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJdND57YfohkECc5nAnrPUtKDDU5gJZZUhmAFIMxcGUCZjVsA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Friday, September 02, 2011 6:51 PM
> To: Bob Pearson
> Cc: linux-kernel@vger.kernel.org; fzago@systemfabricworks.com; Joakim
> Tjernlund; George Spelvin
> Subject: Re: [PATCH v6 05/10] crc32-misc-cleanup.diff
> 
> On Wed, 31 Aug 2011 17:30:12 -0500
> Bob Pearson <rpearson@systemfabricworks.com> wrote:
> 
> > Misc cleanup of lib/crc32.c and related files
> > 	- removed unnecessary header files.
> > 	- straightened out some convoluted ifdef's
> > 	- rewrote some references to 2 dimensional arrays as 1 dimensional
> > 	  arrays to make them correct. I.e. replaced tab[i] with tab[0][i].
> > 	- a few trivial whitespace changes
> > 	- fixed a warning in gen_crc32tables.c caused by a mismatch in the
> > 	  type of the pointer passed to output table. Since the table is
> > 	  only used at kernel compile time, it is simpler to make the table
> > 	  big enough to hold the largest column size used. One cannot make
> the
> > 	  column size smaller in output_table because it has to be used by
> > 	  both the le and be tables and they can have different column
sizes.
> >
> > ...
> >
> > --- for-next.orig/lib/crc32.c
> > +++ for-next/lib/crc32.c
> > @@ -23,13 +23,10 @@
> >  /* see: Documentation/crc32.txt for a description of algorithms */
> >
> >  #include <linux/crc32.h>
> > -#include <linux/kernel.h>
> >  #include <linux/module.h>
> > -#include <linux/compiler.h>
> >  #include <linux/types.h>
> > -#include <linux/init.h>
> > -#include <asm/atomic.h>
> >  #include "crc32defs.h"
> 
> I don't like this bit much.  Surely there's _something_ in here which
> needs kernel.h, and crc32_init() is marked __init so init.h is
> certainly needed.
> 
> Sure, these these things may be accidentally dragged in via nested
> includes but it's bad to depend upon that - such things regularly cause
> breakage when configs are changed.

I tried to copy the usage in other drivers. Happy to oblige.

> 


