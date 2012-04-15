Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2DOSXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 14:23:51 -0400
Received: from smtp.nokia.com ([147.243.128.24]:47597 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2DOSXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 14:23:50 -0400
Date: Sun, 15 Apr 2012 21:18:47 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Jiri Slaby <jslaby@suse.cz>
Cc: apw@canonical.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
Message-ID: <20120415181847.GB22990@pcarmody2.research.nokia.com>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <4F6B51C9.6010904@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6B51C9.6010904@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/12 17:22 +0100, ext Jiri Slaby wrote:
> On 03/22/2012 04:27 PM, Phil Carmody wrote:
> > After HPA's wonderful lkml post, referenced, it seems worth trying to
> > detect this robomatically.
> > 
> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > ---
> >  scripts/checkpatch.pl |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index a3b9782..3993011 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -1881,6 +1881,10 @@ sub process {
> >  				substr($ctx, 0, $name_len + 1, '');
> >  				$ctx =~ s/\)[^\)]*$//;
> >  
> > +				if ($ctx =~ /^\s*(?:\.\.\.)?\s*$/) {
> > +					# HPA explains why: http://lwn.net/Articles/487493/
> > +					ERROR("(...) and () are not sufficiently informative function declarations\n$hereline");
> > +				}
> 
> That explanation is not fully correct. C99 explicitly says (6.7.5.3.14):
> An identifier list declares only the identifiers of the parameters of
> the function. An empty list in a function declarator that is part of a
> definition of that function specifies that the function has no
> parameters. The empty list in a function declarator that is not part of
> a definition of that function specifies that no information about the
> number or types of the parameters is supplied.
> 
> So what you are trying to force here holds only for (forward)
> declarations. Not for functions with definitions (bodies). Is checkpatch
> capable to differ between those?

I know I've already agreed to the above, as it makes perfect sense, but 
I've just come across this, and it appears we're both wrong.

http://www.open-std.org/jtc1/sc22/wg14/www/docs/dr_317.htm
""""
...
void f(){}
...
Question 1: Does such a function definition give the function a type including a prototype for the rest of the translation unit?
...
Committee Response
The grammar states that an empty parens stands for an empty identifier list not an empty parameter-type-list.
The answer to question #1 is NO
"""

So it appears () is never sufficiently informative.
Phil
-- 
Phil Carmody
