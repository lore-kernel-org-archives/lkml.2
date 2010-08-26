Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0HZRLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:11:38 -0400
Received: from xenotime.net ([72.52.115.56]:55821 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751529Ab0HZRLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:11:37 -0400
Date: Thu, 26 Aug 2010 10:11:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Docbook: allow warning on unused documentation
Message-Id: <20100826101130.61f60090.rdunlap@xenotime.net>
In-Reply-To: <1282841476.3812.69.camel@jlt3.sipsolutions.net>
References: <1282136967.13315.1.camel@jlt3.sipsolutions.net>
	<20100826093710.111b103e.rdunlap@xenotime.net>
	<1282841476.3812.69.camel@jlt3.sipsolutions.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 18:51:16 +0200 Johannes Berg wrote:

> On Thu, 2010-08-26 at 09:37 -0700, Randy Dunlap wrote:
> > On Wed, 18 Aug 2010 15:09:27 +0200 Johannes Berg wrote:
> > 
> > > When you don't use !E or !I but only !F, then
> > > it's very easy to miss including some functions,
> > > structs etc. in documentation. To help finding
> > > which ones were missed, allow printing out the
> > > unused ones as warnings.
> > 
> > How do I test this?  Do I need to add !A to some source file?
> 
> Yeah, like to Documentation/DocBook/mac80211.tmpl you could add
> !Ainclude/net/mac80211.h

Yes, I see.  That output looks useful.

How about using !C (for "check") instead of !A ?


> > > +#define _GNU_SOURCE
> > 
> > Can you explain why that is needed?  (curious)
> 
> Yeah, I used asprintf somewhere.

ack.

> > > +static void find_all_symbols(char *filename)
> > > +{
> > > +	char *vec[4]; /* kerneldoc -docbook -function "section" file NULL */
> > 
> > incorrect comment??
> 
> Oops, yes:
> 
> > > +	vec[0] = KERNELDOC;
> > > +	vec[1] = LIST;
> > > +	vec[2] = filename;
> > > +	vec[3] = NULL;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
