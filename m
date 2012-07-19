Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2GSL2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:28:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:7770 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab2GSL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:28:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170331115"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: RE: RE: Charger Manager Proposal.
Thread-Topic: RE: Charger Manager Proposal.
Thread-Index: AQHNWOMfoGqutTxan0+ljIbDUkO2I5cbspOggAwHTgCACM63QA==
Date: Thu, 19 Jul 2012 11:28:06 +0000
Message-ID: <20ADAB092842284E95860F279283C5642CC10F@BGSMSX101.gar.corp.intel.com>
References: <14051592.104301341296077424.JavaMail.weblogic@epml05>
 <20ADAB092842284E95860F279283C5642A1F26@BGSMSX101.gar.corp.intel.com>
 <20120714015648.GA8429@lizard>
In-Reply-To: <20120714015648.GA8429@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6JBSK6I017084

Anton,


> Hm. So Myungjoo thinks that some of the features are compatible. Which do
> you guys think are not compatible? Is this because charger manager does
> everything using a regulator framework? That is, quoting you:
> 
>   "The challenge I see in implementing the above requirements in charger
>    manager is, some of the above requirements are not supported by
>    the regulator framework."
> 
> So, maybe the part of the solution would be enhancing the regulators
> framework?..

I think modifying the regulator framework will not give a cleaner solution. The charger has more properties than  that can be handled by a regulator framework (Like controlling the charger path, CC and CV etc. ). Also wanted to make the charger algorithm event based. So keeping it with power_supply subsystem gives more flexibility to handle events. For example battery temperature change, voltage change, charger/battery status change etc  can be easily hooked to the power_supply_changed_work.

> 
> > The outcome of all the above changes would be that, a set of charging
> algorithms would be available in the mainline and chargers can make use of
> the algorithms without making much modifications to the charger driver
> code. Also this would give a standard framework for monitoring and
> controlling battery charging.
> 
> The idea of plug-in charging algorithms sounds great. So that we could
> choose the algo based on the battery type, charger type etc.
> This is awesome. But do you think you really need a new subsystem for that?
> And if so, will it complement charger manager, compete or substitute it?

The idea is to enhance the power_supply subsystem to plugin charging algorithms. It is not a substitute solution for charger-manager. 
> 
> I would have no problem with complementary subsystem, or just
> evolutionary/incrementally changing the charger-manger (this is surely
> preferred). If you think there is no way for incrementally modifying charger-
> manager for your needs, and you want a "from scratch" solution, this is also
> doable but following requirements are must-have:
> 
> 1. You can prove (on technical merits) that your new charger manager
>    is a complete superset of the old one, and adds some vital features
>    not available before (and these would be hard to implement in
>    terms of the old subsystem);
> 2. You'll have a defined roadmap to convert all charger-manager
>    users to a new subsystem (preferably w/ patches ready).
> 

The new solution is not intended to replace the charger-manager framework. So I think the charger-manager users can continue to use the charger-manager without any change.

> From the past experience, I can tell you that modifying an existing subsystem
> is a much easier way. :-) And the biggest advantage of the current code is
> that it is already well-tested, and incremental changes are easy to bisect.
> 

I agree to your point. We wanted to make use of the power_supply subsystem features as much as possible rather than having a completely new subsystem.

Thanks
-jtc
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
