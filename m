Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2H3VJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:09:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63481 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2H3VJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:09:47 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 Aug 2012 14:09:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
Message-ID: <20120830210959.GA11153@roeck-us.net>
References: <1346351995-9038-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346351995-9038-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:39:55PM -0400, Vivien Didelot wrote:
> The MAX197 is an A/D converter, made by Maxim. This driver currently
> supports the MAX197, and MAX199. They are both 8-Channel, Multi-Range,
> 5V, 12-Bit DAS with 8+4 Bus Interface and Fault Protection.
> 
> The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to
> 10V, while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Hi Vivien,

I have the solution for the platform driver.

enum chips { max197, max199 };

[ ... ]

static struct platform_device_id max197_driver_ids[] = {
        {
		.name = "max197",
		.driver_data = max197,
	}, {
		.name = "max199",
		.driver_data = max199,
	}
};
MODULE_DEVICE_TABLE(platform, max197_driver_ids);

In the probe function:

	enum chips chip = platform_get_device_id(pdev)->driver_data;

This way you only need a single platform driver, no module alias, and you don't
need strcmp() in the probe function to detect the chip type.

Guenter
