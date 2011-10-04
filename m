Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab1JDUmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:42:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59898 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933478Ab1JDUmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:42:38 -0400
Message-ID: <1317760957.18210.15.camel@Joe-Laptop>
Subject: Re: [RFCv3][PATCH 1/4] replace string_get_size() arrays
From: Joe Perches <joe@perches.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com
Date: Tue, 04 Oct 2011 13:42:37 -0700
In-Reply-To: <1317756942.7842.38.camel@nimitz>
References: <20111001000856.DD623081@kernel>
	 <1317497626.22613.1.camel@Joe-Laptop> <1317756942.7842.38.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 12:35 -0700, Dave Hansen wrote:
> On Sat, 2011-10-01 at 12:33 -0700, Joe Perches wrote:
> > On Fri, 2011-09-30 at 17:08 -0700, Dave Hansen wrote:
> > > Instead of explicitly storing the entire string for each
> > > possible units, just store the thing that varies: the
> > > first character.
> > trivia
> I'm not sure what you mean by that.

that what followed wasn't a declaration of defect, just trivial.

> > > diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
> > > --- linux-2.6.git/lib/string_helpers.c~string_get_size-pow2	2011-09-30 16:50:31.628981352 -0700
> > > +++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 17:04:02.211607364 -0700
> > > @@ -8,6 +8,23 @@
> > >  #include <linux/module.h>
> > >  #include <linux/string_helpers.h>
> > >  
> > > +static const char byte_units[] = "_KMGTPEZY";
> > 
> > u64 could be up to ~1.8**19 decimal
> > zetta and yotta are not possible or necessary.
> > u128 maybe someday, but then other changes
> > would be necessary too.
> 
> Right, but we're only handling u64.

So the declaration should be:

	static const char byte_units[] = " KMGTPE";


