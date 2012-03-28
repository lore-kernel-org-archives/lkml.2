Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2C1HX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:23:56 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:41125 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2C1HXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:23:54 -0400
Message-ID: <4F72BD4F.9020305@ladisch.de>
Date: Wed, 28 Mar 2012 09:27:11 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC] Remove most all #define pr_fmt(fmt) lines
References: <1332869030.2213.46.camel@joe2Laptop>
In-Reply-To: <1332869030.2213.46.camel@joe2Laptop>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> With this change, objects like drivers/regulator/core.o
> are prefixed with "core: ".  This is somewhat senseless
> and may prompt Makefile changes to make the prefixes for
> some objects more sensible.
>
> For example, modifying the Makefile to bundle objects
> together with a specific name can change the prefixes.
> Here the prefix becomes "regulator: "
>
> +++ b/drivers/regulator/Makefile
>
> +regulator-y := core.o dummy.o fixed-helper.o
> +regulator-objs := $(regulator-y)
>
> -obj-$(CONFIG_REGULATOR) += core.o dummy.o fixed-helper.o
> +obj-$(CONFIG_REGULATOR) += regulator.o
>
> ------------------
>
> Any objections or other suggestions/improvements?

Instead of doing a Makefile change that has no _obvious_ connection with
printk, wouldn't it be better to just define pr_fmt with "regulator: "?


Regards,
Clemens
