Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1IAQUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:20:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64421 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab1IAQUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:20:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use irq_to_gpio()
Date: Thu, 1 Sep 2011 18:20:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Andrew Chew <AChew@nvidia.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <1314819657-828-1-git-send-email-swarren@nvidia.com> <201109011306.50936.arnd@arndb.de> <74CDBE0F657A3D45AFBB94109FB122FF04B327A2A4@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B327A2A4@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011820.25307.arnd@arndb.de>
X-Provags-ID: V02:K0:UVFsMEN4VBRww9TJs7drRKvBk45SErLPZQHZeNlWyVI
 uTHd1KvVLzZHkTCRfVRxGf4Qm5YYIYpVv/pIevde7YBcbbCsaD
 PggEDvKx3EQ9kREdyy59FiRSW/TGrBik7/3wplYLqRXVzr6yJj
 dGZWjYt8P3dlbs4ofnrJFW2gJzq//MjM5HKFsaNl/q+CkU2kR8
 p4oYmt3oaFvFQI7P7T31b0XNr5rduLmuwXzVgLp1CMImwJBsWK
 PgRnwtCUVLnHgJp40Ccc8X1jFCV1snFahCxWY6KmZQnRxTkeQS
 Ih42LnAkgjI/WUKRBA2pSLq4We0HZLiClEAaWNV5lsYOZxn2B+
 iS9AqkJkQStwa1VTZmNM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 September 2011, Stephen Warren wrote:
> One question: When we add this field, how do drivers tell whether a value
> of 0 is an uninitialized field, or a legitimate GPIO value of 0? Should we
> add a flag to indicate validity, or just work hard to not enable driver-
> side code to use this value until we've fixed up all places that instantiate
> the driver to initialize the field to some invalid value like -1?

I think it's enough to coordinate the driver with the initialization of the
i2c data. If a driver requires a GPIO number, it can assume that it's valid.
Drivers that don't need one don't care. If it's an optional feature, you
might want to either use platform_data after all, or use different identifiers
for devices that have a gpio vs. those that have none -- in effect those are
different types of devices handled by the same driver.

	Arnd
