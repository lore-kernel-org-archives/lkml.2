Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab0GMERQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:17:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56870
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab0GMERO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:17:14 -0400
Date: Mon, 12 Jul 2010 21:17:29 -0700 (PDT)
Message-Id: <20100712.211729.73671287.davem@davemloft.net>
To: dilinger@queued.net
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: move is_root_node from private header to of.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100713200541.0dc8d0be@debxo>
References: <20100713094226.33b421dd@debxo>
	<AANLkTinVpBjQQa93DZ17ULQdspDByGV8h037bVJ2qxGC@mail.gmail.com>
	<20100713200541.0dc8d0be@debxo>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>
Date: Tue, 13 Jul 2010 20:05:41 +0000

> On Mon, 12 Jul 2010 09:53:04 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
> 
>> On Tue, Jul 13, 2010 at 3:42 AM, Andres Salomon <dilinger@queued.net>
>> wrote:
>> >
>> > Make is_root_node available for all archs to use, as it's not
>> > PROM-specific. Also rename it to of_is_root_node, and a few other
>> > minor changes for style/consistency.
>> >
>> > Signed-off-by: Andres Salomon <dilinger@queued.net>
>> > ---
>> >  arch/sparc/kernel/prom.h        |    8 --------
>> >  arch/sparc/kernel/prom_64.c     |    6 +++---
>> >  arch/sparc/kernel/prom_common.c |    2 +-
>> >  include/linux/of.h              |    8 ++++++++
>> >  4 files changed, 12 insertions(+), 12 deletions(-)
>> [...]
>> > diff --git a/include/linux/of.h b/include/linux/of.h
>> > index a367e19..b38cdf7 100644
>> > --- a/include/linux/of.h
>> > +++ b/include/linux/of.h
>> > @@ -97,6 +97,14 @@ extern struct device_node *of_node_get(struct
>> > device_node *node); extern void of_node_put(struct device_node
>> > *node); #endif
>> >
>> > +static inline bool of_is_root_node(const struct device_node *node)
>> > +{
>> > +       if (!node)
>> > +               return false;
>> > +
>> > +       return (node->parent == NULL);
>> > +}
>> 
>> Are you okay if I shorten this to?
>> 
>> +static inline bool of_is_root_node(const struct device_node *node)
>> +{
>> +       return (node && (node->parent == NULL));
>> +}
>> 
>> g.
> 
> It's fine with me.
> 

Me too:

Acked-by: David S. Miller <davem@davemloft.net>
