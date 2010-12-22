Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab0LVNds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:33:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42951 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751739Ab0LVNdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:33:47 -0500
Date: Wed, 22 Dec 2010 13:33:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 5/6] MFD MAX8998/LP3974: Charger Support
Message-ID: <20101222133359.GF26306@opensource.wolfsonmicro.com>
References: <20101221155004.GA21871@opensource.wolfsonmicro.com>
 <1292998991-26968-6-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292998991-26968-6-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 03:23:10PM +0900, MyungJoo Ham wrote:
> With the new regulator, "CHARGER", users can control charging
> current and turn on and off the charger. Note that the charger
> specification of LP3974 is different from that of MAX8998.
> 
> "CHARGER_ONLINE" monitors the charger status, which can be
> different from the status "CHARGER"; e.g., users allowed the charger
> to charge, but the MAX8998 chip decided not to do so.
> 
> "BATTERY_ONLINE" monitors the battery status (the existence of the
> battery).

Normally I'd expect a battery charger to be exposed via the power supply
API - I'd at least expect to see a consumer in the power supply API
which manages the charger and given the amount of automation you usually
see in chargers integrated into PMICs (things like automatically
starting and stopping themselves) it's not entirely clear that they map
on that well to the regulator API.
