Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2CVRwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:52:51 -0400
Received: from smtp.nokia.com ([147.243.1.48]:18952 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab2CVRwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:52:49 -0400
Date: Thu, 22 Mar 2012 19:48:02 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: "ext H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Slaby <jslaby@suse.cz>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
Message-ID: <20120322174802.GE19970@pcarmody2.research.nokia.com>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <4F6B51C9.6010904@suse.cz>
 <4F6B5902.1080607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6B5902.1080607@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/12 09:53 -0700, ext H. Peter Anvin wrote:
> On 03/22/2012 09:22 AM, Jiri Slaby wrote:
> > 
> > That explanation is not fully correct. C99 explicitly says (6.7.5.3.14):
> > An identifier list declares only the identifiers of the parameters of
> > the function. An empty list in a function declarator that is part of a
> > definition of that function specifies that the function has no
> > parameters. The empty list in a function declarator that is not part of
> > a definition of that function specifies that no information about the
> > number or types of the parameters is supplied.
> > 
> > So what you are trying to force here holds only for (forward)
> > declarations. Not for functions with definitions (bodies). Is checkpatch
> > capable to differ between those?
> 
> We shouldn't use it anyway.  gcc might take it that way in C99 mode, but
> it's unclear if it does it in the default mode, and having declarators
> and definitions be different is just asking for trouble.

This perhaps? (And my support goes to any better rewordings.)


From: Phil Carmody <ext-phil.2.carmody@nokia.com>
Date: Thu, 22 Mar 2012 19:40:47 +0200
Subject: [PATCH 2/2] Documentation/CodingStyle: outlaw () use (void)

While empty paramter lists in function definitions are not technically
wrong, those situations are rare enough that it's worth encouraging
people towards a more uniform, always unambiguous, style.
http://lkml.org/lkml/2012/3/22/241

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 Documentation/CodingStyle |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 2b90d32..c4b9df7 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -381,6 +381,8 @@ EXPORT_SYMBOL(system_is_up);
 In function prototypes, include parameter names with their data types.
 Although this is not required by the C language, it is preferred in Linux
 because it is a simple way to add valuable information for the reader.
+Do not use empty parameter lists, as they sometimes mean one thing and
+sometimes mean another - avoid ambiguity by using (void).
 
 
 		Chapter 7: Centralized exiting of functions
-- 
1.7.2.5
