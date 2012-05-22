Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2EVIEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:04:31 -0400
Received: from smtp.nokia.com ([147.243.1.47]:36957 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2EVIEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:04:25 -0400
Date: Tue, 22 May 2012 11:01:23 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
Message-ID: <20120522080123.GD25862@pcarmody2.research.nokia.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1337288048.17726.64.camel@joe2Laptop>
 <20120517211641.GC27953@pcarmody2.research.nokia.com>
 <1337289897.8872.8.camel@joe2Laptop>
 <20120521120511.GG1197@pcarmody2.research.nokia.com>
 <1337618463.13010.4.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337618463.13010.4.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/12 09:41 -0700, ext Joe Perches wrote:
> On Mon, 2012-05-21 at 15:05 +0300, Phil Carmody wrote:
> > +# check for deliberate avoidance of the above anti-typedef rule
> > +               if ($line =~ /#\s*define\s+$Ident\s+(enum|union|struct)\s+$Ident\b/) {
 
> I believe this would not catch,
> 
> #define typedeflike_define_t	\
> 	struct foo
> 
> If it's deliberate, you probably want to.
> 
> So maybe you want to move this and use
> the $stat tests like the extern or memset
> tests do (look around line 3200).

Thanks for the pointer. This flags everything I'm interested in:

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index faea0ec..408aee0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3319,6 +3319,13 @@ sub process {
                             "externs should be avoided in .c files\n" .  $herecurr);
                }
 
+# check for deliberate avoidance of the anti-typedef rule
+               if (defined $stat &&
+                   $stat =~ /#\s*define\s+$Ident\s+(enum|union|struct)\s+$Ident\b/) {
+                       WARN("NEW_TYPEDEFS",
+                            "do not fake typedefs using #define\n" . $herecurr);
+               }
+
 # checks for new __setup's
                if ($rawline =~ /\b__setup\("([^"]*)"/) {
                        my $name = $1;

-- 
Phil Carmody
Tel: +372 5697 1161 
