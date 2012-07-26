Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2GZRGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:06:22 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33739 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2GZRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:06:20 -0400
Date: Thu, 26 Jul 2012 10:04:11 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] power_supply: Added support for power supply
 attribute sources
Message-ID: <20120726170411.GA19112@lizard>
References: <1343315844-18824-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343315844-18824-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ramakrishna,

On Thu, Jul 26, 2012 at 08:47:24PM +0530, Ramakrishna Pallala wrote:
> On some platforms one driver(or HW chip) may not be able to provide all
> the necessary attributes of the power supply connected to the platform or
> may provide very limited info which can be used by core/primary drivers.
> 
> For example a temperature sensor chip placed near the battery can be used
> to report battery ambient temperature but it does not makes sense to register
> sensor driver with power supply class. Or even a ADC driver or platform
> driver may report power supply properties like voltage/current or charging
> status but registering all those driver with power supply class is not a
> practical or ideal approach.
> 
> This patch adds the generic support to register the drivers as power
> supply attribute(properties) sources and adds an interface to read
> these attributes from power supply class drivers.
> 
> If there are multiple attribute sources of the same type then caller has
> to do source selection by passing the source string in the query struct.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
[...]
> +extern int power_supply_attributes_register(struct device *parent,
> +				struct power_supply_attr_source *psy_attr);

Can you please show some user of the new calls? If I understand
correctly, you're going to call these from sensing (ADC, or some
other) drivers, which would be very very wrong thing to do.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
