Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738Ab2EQVTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:19:41 -0400
Received: from smtp.nokia.com ([147.243.1.48]:27414 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab2EQVTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:19:39 -0400
Date: Fri, 18 May 2012 00:16:41 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
Message-ID: <20120517211641.GC27953@pcarmody2.research.nokia.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1337288048.17726.64.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337288048.17726.64.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/12 13:54 -0700, ext Joe Perches wrote:
> > +# check for deliberate avoidance of the above anti-typedef rule
> > +		if ($line =~ /#\s*define\s+$Ident\s+$Type\b/) {
> > +			WARN("NEW_TYPEDEFS",
> > +			     "do not fake typedefs using #define\n" . $herecurr);
> > +		}
> > +
> 
> I think the false positive rate is pretty high.
> I used this and don't see too many I'd remove.
> 
> $ git grep -E "#\s*define\s+\w+\s+(struct|unsigned|char|short|int|long|const)\b"
> 
> Got an example you want this to find?

Too many. Alas I can't share them. However, your input is most welcome, and that
grep shows that my regexp is *way* too broad. So auto-NACK-ing, and I'll now work
on something that doesn't include most of the above hits. Suggestions for a regexp
banning the fake typedefs that would get flagged were they to be mapped onto a 
typedef would be most welcome. The context I'm seeing them is a clear checkpatch
avoidance mess, and I'd like to see it similarly flagged.

Cheers,
Phil
-- 
Phil Carmody
Tel: +372 5697 1161 
