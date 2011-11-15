Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab1KOShB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:37:01 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19341 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1KOShA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:37:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Nov 2011 10:36:59 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "arnd@arndb.de" <arnd@arndb.de>
Date: Tue, 15 Nov 2011 10:36:57 -0800
Subject: RE: [PATCH 1/1] gpio: introduce gpio_export_array to ease export
 for gpio arrays
Thread-Topic: [PATCH 1/1] gpio: introduce gpio_export_array to ease export
 for gpio arrays
Thread-Index: AcyjeuPVaDWSXoVhQ76+M7SgSFsgQQASk2PA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805DEC@HQMAIL01.nvidia.com>
References: <1321350841-8549-1-git-send-email-dong.aisheng@linaro.org>
In-Reply-To: <1321350841-8549-1-git-send-email-dong.aisheng@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Tuesday, November 15, 2011 2:54 AM:
> Introduce gpio_export_array function to ease the export operation
> for gpio arrays.
> This can cooperate with the exist gpio_request_array function.
...
> +/**
> + * gpio_export_array - export multiple GPIOs in a single call
> + * @array:	array of the 'struct gpio'
> + * @num:	how many GPIOs in the array
> + */
> +int gpio_export_array(const struct gpio *array, size_t num,
> +			bool direction_may_change)

Should direction_may_change be added to "struct gpio" so it can vary
per pin?

I might this new function to create its own parameter type instead of
re-using struct gpio, but I guess the main value here is re-using the
data passed to both request_array and export_array.

-- 
nvpublic

