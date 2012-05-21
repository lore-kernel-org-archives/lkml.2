Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2EUMIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:08:14 -0400
Received: from smtp.nokia.com ([147.243.1.47]:31355 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2EUMIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:08:13 -0400
Date: Mon, 21 May 2012 15:05:11 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
Message-ID: <20120521120511.GG1197@pcarmody2.research.nokia.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1337288048.17726.64.camel@joe2Laptop>
 <20120517211641.GC27953@pcarmody2.research.nokia.com>
 <1337289897.8872.8.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337289897.8872.8.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/12 14:24 -0700, ext Joe Perches wrote:
> On Fri, 2012-05-18 at 00:16 +0300, Phil Carmody wrote:
> > On 17/05/12 13:54 -0700, ext Joe Perches wrote:
> > > > +# check for deliberate avoidance of the above anti-typedef rule
> > > > +		if ($line =~ /#\s*define\s+$Ident\s+$Type\b/) {
> > > > +			WARN("NEW_TYPEDEFS",
> > > > +			     "do not fake typedefs using #define\n" . $herecurr);
> > > > +		}
> > > > +
> > > 
> > > I think the false positive rate is pretty high.
> > > I used this and don't see too many I'd remove.
> > > 
> > > $ git grep -E "#\s*define\s+\w+\s+(struct|unsigned|char|short|int|long|const)\b"

I hadn't actually run that before, but to be honest, I think
few of them have much justification. Or at least, were that
code to be written today by one of the regular contributors,
it probably wouldn't be written with such a #define. A lot
do go directly against the advice in Documentation/CodingStyle.

> > > Got an example you want this to find?
> > 
> > Too many. Alas I can't share them.
> 
> Too bad.
> 
> If all the defines end in _t maybe you could use
> 	if ($line =~ /^\+\s*#\s*define\s+\w+_t\s+$Type\b/) {
> etc...
> 

Well, certainly structs are the majority of the immediate ones I'd
most like to nail, so how about this:

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index faea0ec..0db7f84 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2299,6 +2299,12 @@ sub process {
                             "do not add new typedefs\n" . $herecurr);
                }
 
+# check for deliberate avoidance of the above anti-typedef rule
+               if ($line =~ /#\s*define\s+$Ident\s+(enum|union|struct)\s+$Ident\b/) {
+                       WARN("NEW_TYPEDEFS",
+                            "do not fake typedefs using #define\n" . $herecurr);
+               }
+
 # * goes on variable not on type
                # (char*[ const])
                while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {


-- 
Phil Carmody
Tel: +372 5697 1161 
