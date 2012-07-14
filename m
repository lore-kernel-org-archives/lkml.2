Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab2GNB65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 21:58:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57804 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2GNB6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 21:58:55 -0400
Date: Fri, 13 Jul 2012 18:56:48 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        cw00.choi@samsung.com, kyungmin.park@samsung.com
Subject: Re: RE: Charger Manager Proposal.
Message-ID: <20120714015648.GA8429@lizard>
References: <14051592.104301341296077424.JavaMail.weblogic@epml05>
 <20ADAB092842284E95860F279283C5642A1F26@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C5642A1F26@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:20:22AM +0000, Tc, Jenny wrote:
> Since modifying the charger manager for the below requirements would be more complex and would not fit inside the charger manager we are thinking of implementing new framework under power_supply subsystem with following features.

I'm not an expert in charger-manager sub-subsystem; if you guys want
to, I can dig into it, but I'd rather prefer if you come to some
agreement w/o my intervention.

Quoting Myungjoo from the previous email:

  "I think the features mentioned above are good to be included in
   charger manager as they look quite compatible with current structure
   with some modifications."

Hm. So Myungjoo thinks that some of the features are compatible. Which do
you guys think are not compatible? Is this because charger manager does
everything using a regulator framework? That is, quoting you:

  "The challenge I see in implementing the above requirements in charger
   manager is, some of the above requirements are not supported by
   the regulator framework."

So, maybe the part of the solution would be enhancing the regulators
framework?..

> The outcome of all the above changes would be that, a set of charging algorithms would be available in the mainline and chargers can make use of the algorithms without making much modifications to the charger driver code. Also this would give a standard framework for monitoring and controlling battery charging.

The idea of plug-in charging algorithms sounds great. So that we
could choose the algo based on the battery type, charger type etc.
This is awesome. But do you think you really need a new subsystem
for that? And if so, will it complement charger manager, compete
or substitute it?

I would have no problem with complementary subsystem, or just
evolutionary/incrementally changing the charger-manger (this is
surely preferred). If you think there is no way for incrementally
modifying charger-manager for your needs, and you want a "from
scratch" solution, this is also doable but following requirements
are must-have:

1. You can prove (on technical merits) that your new charger manager
   is a complete superset of the old one, and adds some vital features
   not available before (and these would be hard to implement in
   terms of the old subsystem);
2. You'll have a defined roadmap to convert all charger-manager
   users to a new subsystem (preferably w/ patches ready).

>From the past experience, I can tell you that modifying an existing
subsystem is a much easier way. :-) And the biggest advantage of the
current code is that it is already well-tested, and incremental
changes are easy to bisect.

There were precedents of rewriting drivers and subsystems completely,
so it is nothing new as well. But I urge you to think about it twice.

Thanks,


p.s.

Btw, frankly speaking I'm not so much happy about charger-manager
nowadays, not from the design point of view (and not because it
seems quite complex -- I presume there is a reason for that), but
I'm somewhat unhappy about implementation details, i.e. I complained[1]
about its uevents implementation, but no one seem to bother to fix
that. I see a good flow of new features and interest for the charger
manager (which is great), but the long standing pesky issues are still
there.

So, if you'll have a somewhat more clean uevents implementation, that
would be surely a good point for the new subsystem. :-D

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1205.0/02398.html

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
