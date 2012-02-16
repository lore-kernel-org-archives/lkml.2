Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2BPOkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:40:23 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:23183 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2BPOkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:40:22 -0500
MIME-Version: 1.0
Message-ID: <c6634d7c-b264-4a87-bab1-74408341dab0@default>
Date: Thu, 16 Feb 2012 06:39:42 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: linux-next: build failure after merge of the staging tree
References: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
 <20120216051552.GA5676@kroah.com>
In-Reply-To: <20120216051552.GA5676@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F3D1536.00C1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:greg@kroah.com]
> Subject: Re: linux-next: build failure after merge of the staging tree
> 
> On Thu, Feb 16, 2012 at 03:23:16PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> >
> > After merging the staging tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > drivers/staging/ramster/zcache-main.c:2969:2: error: unknown field 'invalidate_page' specified in
> initializer
> > drivers/staging/ramster/zcache-main.c:2970:2: error: unknown field 'invalidate_inode' specified in
> initializer
> > drivers/staging/ramster/zcache-main.c:2971:2: error: unknown field 'invalidate_fs' specified in
> initializer
> >
> > I do wonder if any of this was build tested with CONFIG_CLEANCACHE enabled ...

Absolutely, against next-20120214, which contained commit

91c6cc9b5c216bd067f9af2cc64fcbe190755865

which changed the names of those fields from "flush*" to "invalidate*".
I am the author of that commit but it is pulled through Konrad Wilk
(cc'ed). Perhaps Konrad's pull succeeded in next-20120214 but
failed in next-20120215?

Kernel.org seems to be down so I can't see if that commit is
in next-20120215 but if it is not that would likely cause
the above errors.

> > Caused by commit 19ee3ef5f4bb ("staging: ramster: local compression + tmem").
> >
> > I have used the staging tree from next-20120215 for today.
> 
> Dan, can you please fix this?

Hmmm... moving target.  I'm trying to get in touch with Konrad
to see if we can determine what is going on.

The good news is that there seems to be an increasing number
of people contributing to and building things on top of
cleancache/frontswap stuff.  The bad news is that it is difficult
to avoid ordering dependencies that affect -next.  My apologies
and if you have any dependency-savvy processes that would solve
this that we are not using, please let me/us know.
