Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab2GCUIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:08:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23266 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab2GCUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:08:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6761"; a="204850430"
Message-ID: <4FF3514E.6050401@codeaurora.org>
Date: Tue, 03 Jul 2012 13:08:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix recursive mutex lockdep warning
References: <1341282066-15325-1-git-send-email-sboyd@codeaurora.org> <20120703192652.GH29030@opensource.wolfsonmicro.com>
In-Reply-To: <20120703192652.GH29030@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/12 12:26, Mark Brown wrote:
> On Mon, Jul 02, 2012 at 07:21:06PM -0700, Stephen Boyd wrote:
>> A recursive lockdep warning occurs if you call
>> regulator_set_optimum_mode() on a regulator with a supply because
>> there is no nesting annotation for the rdev->mutex. To avoid this
>> warning, get the supply's load before locking the regulator's
>> mutex to avoid grabbing the same class of lock twice.
> Applied, thanks.  Though we should probably just remove the optimal mode
> stuff on account of the total absence of any users...

Please don't remove it. We use the optimal stuff fairly often
internally, plus our usb driver is upstream and using the API.

What do you think about removing the locking in get_voltage? Is that better?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

