Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab2LUIF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:05:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19477 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2LUIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:05:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 21 Dec 2012 00:04:09 -0800
Message-ID: <50D41860.7040406@nvidia.com>
Date: Fri, 21 Dec 2012 16:05:52 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Durgadoss R <durgadoss.r@intel.com>
CC: "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: Re: [PATCH 0/8] Thermal Framework Enhancements
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
In-Reply-To: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 05:29 PM, Durgadoss R wrote:
> This patch is a v1 based on the RFC submitted here:
> https://patchwork.kernel.org/patch/1758921/
> 
> This patch set is based on Rui's -thermal tree, and is
> tested on a Core-i5 and an Atom netbook.
> 
> This series contains 8 patches:
> Patch 1/8: Creates new sensor level APIs
> Patch 2/8: Creates new zone level APIs. The existing tzd structure is
>            kept as such for clarity and compatibility purposes.
> Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
>            existing tcd structure need not be modified.
> Patch 4/8: Adds a thermal_trip sysfs node, which exposes various trip
>            points for all sensors present in a zone.
> Patch 5/8: Adds a thermal_map sysfs node. It is a compact representation
>            of the binding relationship between a sensor and a cdev,
>            within a zone.
> Patch 6/8: Creates Documentation for the new APIs. A new file is
>            created for clarity. Final goal is to merge with the existing
>            file or refactor the files, as whatever seems appropriate.
> Patch 7/8: Make PER ZONE values configurable through Kconfig
> Patch 8/8: A dummy driver that can be used for testing. This is not for merge.

I read these patches, they create new APIs and sysfs, but it seems they
didn't use the thermal_zone to handle the thermal_throttle issue,
something like update thermal_zone, update temperature, handle governors
when cross the trip temp. So will you send out next serial patches for
these implementation?

> 
> Thanks to Rui Zhang, Honghbo Zhang, Wei Ni for their feedback on the
> RFC version.
> 
> Durgadoss R (8):
>   Thermal: Create sensor level APIs
>   Thermal: Create zone level APIs
>   Thermal: Add APIs to bind cdev to new zone structure
>   Thermal: Add Thermal_trip sysfs node
>   Thermal: Add 'thermal_map' sysfs node
>   Thermal: Add Documentation to new APIs
>   Thermal: Make PER_ZONE values configurable
>   Thermal: Dummy driver used for testing
> 
>  Documentation/thermal/sysfs-api2.txt |  248 +++++++++
>  drivers/thermal/Kconfig              |   19 +
>  drivers/thermal/Makefile             |    3 +
>  drivers/thermal/thermal_sys.c        |  932 ++++++++++++++++++++++++++++++++++
>  drivers/thermal/thermal_test.c       |  315 ++++++++++++
>  include/linux/thermal.h              |  124 +++++
>  6 files changed, 1641 insertions(+)
>  create mode 100644 Documentation/thermal/sysfs-api2.txt
>  create mode 100644 drivers/thermal/thermal_test.c
> 

