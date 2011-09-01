Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1IALHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:07:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab1IALHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:07:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't use irq_to_gpio()
Date: Thu, 1 Sep 2011 13:06:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Andrew Chew <AChew@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <1314819657-828-1-git-send-email-swarren@nvidia.com> <643E69AA4436674C8F39DCC2C05F76383CF3C784A3@HQMAIL03.nvidia.com> <4E5F49F4.2080208@cam.ac.uk>
In-Reply-To: <4E5F49F4.2080208@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011306.50936.arnd@arndb.de>
X-Provags-ID: V02:K0:z5+PSUsuqm8IRvia9ix1XHBh2B5zK/bMt9fB8ygvtlU
 C2b1nuIG3gP8PVWJh3nGcp7osMFWO/azlnsBFpfnzO4R6AJa5D
 SZeE43oRZZiSAIURy2MD0NhKQ/OWTujoFEipujM7ez0zp229s2
 SdgfrBRoLd8z/WxzgCwQ8heVQnTktCk8wj7UreLKCMJZwtyhpe
 PCumKyl20aOdijT8HZC7IhoUSXO+xY4xt1aWzwTkzU/PI3+g1k
 twQZ7MrO14uTLNDr6/amHHRfY08rEzB1QZZHHqmYr6vVCIvomH
 kWl6VvzlEBAAFk9E2sbd//Qv8O8YeEJXJW+QL/ylyZUF+33S4R
 PHbIQ6DgIVp1O2ZrnUJM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 September 2011, Jonathan Cameron wrote:
> On 08/31/11 20:45, Andrew Chew wrote:
> >> Subject: [PATCH 1/3] staging:iio:magnetometer:ak8975 Don't 
> >> use irq_to_gpio()
> >>
> >> Tegra doesn't have irq_to_gpio() any more, and ak8975 is included in
> >> tegra_defconfig. This causes a build failure. Solve this with 
> >> a heavy-handed
> >> method for now.
> >>
> >> I suspect the long-term solution is to pass both the IRQ and GPIO IDs
> >> to the driver; the GPIO ID coming from either platform data, 
> >> or perhaps
> >> enhancing struct i2c_client to add a gpio field alongside irq.
> >>
> >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >> ---
> > 
> > The three patches in this set LGTM.
> > 
> > Acked-by: Andrew Chew <achew@nvidia.com> 
> > 
> 
> Hmm.. I'd like to see some means of passing that in. Perhaps as simple as passing
> a pointer to an int in as platform_data.  Patch to follow.

My feeling is that we should just add another field to
struct i2c_client. There are probably more drivers that
need the same thing, making it appropriate to increase
the size of that struct for everything device instead of
adding platform_data to a subset of the devices.

	Arnd
