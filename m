Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0CRQvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:51:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60600 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0CRQvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100318154747.GA7767@oksana.dev.rtsoft.ru>
References: <20100318144836.21082.93040.stgit@angua> <20100318152250.21082.35352.stgit@angua> 
	<20100318154747.GA7767@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 18 Mar 2010 10:22:14 -0600
X-Google-Sender-Auth: d7fccbacfb17b60e
Message-ID: <fa686aa41003180922g3e867bedo337568c3ca6f2097@mail.gmail.com>
Subject: Re: [V2 PATCH 08/10] arch/powerpc: Remove obsolete 
	dev_archdata.of_node and of_devce.node
To: avorontsov@ru.mvista.com
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 9:47 AM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> Hi Grant,
>
> On Thu, Mar 18, 2010 at 09:22:50AM -0600, Grant Likely wrote:
>> Both dev_archdata.of_node and of_device.node are duplications of the
>> device.of_node value.  This patch removes them.
>
> Yeah, they're plain duplications since you introduced dev.of_node.
> I wonder what was the problem with using dev.archdata.of_node?
> Why dev.of_node is better?

CONFIG_OF support is not going to be an arch-specific thing any
longer.  The code is being generalized, and I'm removing as many
things as possible that arch code needs to add to enable CONFIG_OF.
That includes the dev_archdata element.

The impact of moving of_node from dev_archdata to device is pretty
small anyway.  Most current users are getting the device node from
of_device.node instead of archdata.  The number of dev_archdata users
is comparatively small.

> Also, by using dev.of_node directly you have to introduce ugly
> #ifdefs in the non-OF code (as in i2c patch), which you don't
> need with transparent archdata and accessors, which you've just
> removed:

The #ifdefs are only needed in the i2c code because the i2c API
doesn't currently support separate allocation and registration of i2c
devices.  With separate allocation and registration, the of_i2c code
could set the device node pointer directly without touching the common
i2c code at all (like how of_register_spi_devices handles it).  I do
plan to write a patch to do this, but that is a task for another patch
series.

g.
