Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0HZQvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:51:20 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0HZQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:51:18 -0400
Subject: Re: [RFC] Docbook: allow warning on unused documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100826093710.111b103e.rdunlap@xenotime.net>
References: <1282136967.13315.1.camel@jlt3.sipsolutions.net>
	 <20100826093710.111b103e.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 18:51:16 +0200
Message-ID: <1282841476.3812.69.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 09:37 -0700, Randy Dunlap wrote:
> On Wed, 18 Aug 2010 15:09:27 +0200 Johannes Berg wrote:
> 
> > When you don't use !E or !I but only !F, then
> > it's very easy to miss including some functions,
> > structs etc. in documentation. To help finding
> > which ones were missed, allow printing out the
> > unused ones as warnings.
> 
> How do I test this?  Do I need to add !A to some source file?

Yeah, like to Documentation/DocBook/mac80211.tmpl you could add
!Ainclude/net/mac80211.h

> > +#define _GNU_SOURCE
> 
> Can you explain why that is needed?  (curious)

Yeah, I used asprintf somewhere.

> > +static void find_all_symbols(char *filename)
> > +{
> > +	char *vec[4]; /* kerneldoc -docbook -function "section" file NULL */
> 
> incorrect comment??

Oops, yes:

> > +	vec[0] = KERNELDOC;
> > +	vec[1] = LIST;
> > +	vec[2] = filename;
> > +	vec[3] = NULL;

johannes

