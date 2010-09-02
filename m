Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0IBLmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 07:42:44 -0400
Received: from www84.your-server.de ([213.133.104.84]:41864 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0IBLmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 07:42:43 -0400
Subject: Re: [PATCH] Add quick erase format option
From: Stefani Seibold <stefani@seibold.net>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Enzinger, Robert (EXT-Other - DE/Munich)" 
	<robert.enzinger.ext@nsn.com>
In-Reply-To: <1283425100.3085.5.camel@brekeke>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
	 <1281353344.2332.8.camel@brekeke>
	 <1281362069.20181.16.camel@wall-e.seibold.net>
	 <1283081435.2131.24.camel@brekeke>
	 <1283236978.6083.28.camel@wall-e.seibold.net>
	 <1283302043.2018.92.camel@brekeke>
	 <1283410392.6920.36.camel@wall-e.seibold.net>
	 <1283425100.3085.5.camel@brekeke>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 02 Sep 2010 13:42:43 +0200
Message-ID: <1283427763.9613.0.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 02.09.2010, 13:58 +0300 schrieb Artem Bityutskiy:
> On Thu, 2010-09-02 at 08:53 +0200, Stefani Seibold wrote: 
> > --do-not-use-me is the best. But more seriously i think we should it
> > split it into two options. --all-erased and --check-erased. The first
> > assumes that all PEB are erased, while the second do the check if the
> > PEB is erased and if not it will be erased.
> > 
> > So we can handle NAND's, which have a fast erase, and NOR's  which are
> > very slow. With this we are able to pick the best option for the
> > manufacturing.
> 
> I am fine with checking, but what bothers me is that you check only 64
> bytes out of 128KiB - why this is enough to make sure the eraseblock is
> erased?
> 
> Probably it is ok for you, but in for general use-case this is wrong,
> even checking all 128KiB is wrong, because of the unstable bits.
> 
> What I think will make more sense is to add general option --verify or
> something like that. It would read everything the utility wrote and
> verify it is identical to what was written. Probably this can be done in
> libmtd.
> 
> Then you will be able to combine --all-erased with --verify and achieve
> what you want.
> 

Agree. I will create a patch for this in the next few days.

- Stefani


