Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab2COKE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:04:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49465 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab2COKEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:04:53 -0400
Date: Thu, 15 Mar 2012 11:04:56 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
In-reply-to: <20120314172915.GB13393@sirena.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F61BEC8.4030008@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
 <20120314172915.GB13393@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.03.2012 18:29, Mark Brown wrote:

> On Tue, Mar 13, 2012 at 05:54:38PM +0100, Karol Lewandowski wrote:
> 
>>  - replace s3c24xx_i2c_type enum with plain unsigned int that can
>>    hold not only device type but also hw revision-specific quirks
> 
> Would it not be clearer to just have explicit flags for the quirks (eg,
> as a set of bitfield flags)?


That would work on runtime but we also need to initialize this
somehow.  The way it was done today on non-dt platforms is via platform
device variants, i.e. (taken from 3rd patch):

@@ -1128,6 +1161,9 @@ static struct platform_device_id s3c24xx_driver_ids[] = {
 	}, {
 		.name		= "s3c2440-i2c",
 		.driver_data	= TYPE_S3C2440,
+	}, {
+		.name		= "s3c2440-hdmiphy-i2c",
+		.driver_data	= TYPE_S3C2440 | FLAG_HDMIPHY | FLAG_NO_GPIO,

Ability to address above scenario was sole motivation for this change.
Without it one would need either need separate type (e.g. 
TYPE_S3C2440_HDMIPHY) or setting flags based just on device name.

Introducing separate type (TYPE_S3C2440_HDMIPHY) has been our original
attempt to solve this issue.  However, this required adding explicit
checks to driver code all over the place (if (type == S3C2400 ||
type == S3c2440_HDMIPHY).

Thus, I felt that sqeezing quirks into type is a bit cleaner approach.

Regards,
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
