Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab2JaWHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:07:24 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:60379 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab2JaWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:07:23 -0400
Subject: Re: [RFC 1/7] capebus: Core capebus support
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CA+Bv8XZ5WnhsKqYA6TBv8wh6OvOdU-G8XhuV2dO49O1qX_FRgg@mail.gmail.com>
Date: Thu, 1 Nov 2012 00:07:18 +0200
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EBB972CD-D9D9-4704-AABF-2DFCED584297@antoniou-consulting.com>
References: <1351702333-8456-1-git-send-email-panto@antoniou-consulting.com> <1351702333-8456-2-git-send-email-panto@antoniou-consulting.com> <CA+Bv8XZ5WnhsKqYA6TBv8wh6OvOdU-G8XhuV2dO49O1qX_FRgg@mail.gmail.com>
To: Russ Dill <Russ.Dill@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 31, 2012, at 11:55 PM, Russ Dill wrote:

> On Wed, Oct 31, 2012 at 9:52 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
>> Introducing capebus; a bus that allows small boards (capes) to connect
>> to a complex SoC using simple expansion connectors.
>> 

[snip]
>> +       if (drv) {
>> +               /* call the removed bus method (if added prev.) */
>> +               if (cape_dev->added) {
>> +                       BUG_ON(cape_dev->bus == NULL);
>> +                       BUG_ON(cape_dev->bus->ops == NULL);
>> +                       if (cape_dev->bus->ops->dev_removed)
>> +                               cape_dev->bus->ops->dev_removed(cape_dev);
>> +                       cape_dev->added = 0;
>> +               }
> 
> Is there any case where added will not track drv?


Yes, there is a corner case here.

There is the case where while the device is created there is no matching
driver yet. Either that's the case of a not supported cape, or the
cape driver hasn't been loaded yet.

We do need the device to be created, so that the user can browse in the
sysfs it's eeprom attributes.

There's some further complications with runtime cape overrides, but
that's the gist of it.


>> --
>> 1.7.12
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards

-- Pantelis

