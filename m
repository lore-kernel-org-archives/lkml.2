Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2HBJfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 05:35:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53861 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2HBJfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 05:35:46 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.46.74
Date: Thu, 2 Aug 2012 02:35:36 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120802093536.GA23089@leaf>
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com>
 <1343757920-19713-2-git-send-email-levinsasha928@gmail.com>
 <20120731182330.GD21292@google.com>
 <50197348.9010101@gmail.com>
 <20120801182112.GC15477@google.com>
 <50197460.8010906@gmail.com>
 <20120801182749.GD15477@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801182749.GD15477@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:27:49AM -0700, Tejun Heo wrote:
> On Wed, Aug 01, 2012 at 08:24:32PM +0200, Sasha Levin wrote:
> > On 08/01/2012 08:21 PM, Tejun Heo wrote:
> > > On Wed, Aug 01, 2012 at 08:19:52PM +0200, Sasha Levin wrote:
> > >> If we switch to using functions, we could no longer hide it anywhere
> > >> (we'd need to either turn the buckets into a struct, or have the
> > >> user pass it around to all functions).
> > > 
> > > Create an outer struct hash_table which remembers the size?
> > 
> > Possible. I just wanted to avoid creating new structs where they're not really required.
> > 
> > Do you think it's worth it for eliminating those two macros?
> 
> What if someone wants to allocate hashtable dynamically which isn't
> too unlikely?

In particular, once this goes in, I'd like to add RCU-based hash
resizing to it, which will require wrapping the hash table in a struct
that also contains the size.  So, please do consider having such a
struct rather than relying on static array sizes.

- Josh Triplett
