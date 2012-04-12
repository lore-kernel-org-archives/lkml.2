Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398Ab2DLJhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:37:53 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:38306 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762323Ab2DLJhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:37:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F86A26B.1090209@cam.ac.uk>
Date: Thu, 12 Apr 2012 10:37:47 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V2 2/2] staging: Documentation: add proximity_sampling_period
 as sysfs details
References: <1334214492-23044-1-git-send-email-ldewangan@nvidia.com> <1334214492-23044-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1334214492-23044-3-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 8:08 AM, Laxman Dewangan wrote:
> Add the sysfs proximity_sampling_period for sampling period of
> proximity sensing.
>
> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> ---
>   .../staging/iio/Documentation/sysfs-bus-iio-light  |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> index edbf470..9d6108b 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> @@ -83,3 +83,10 @@ Description:
>   		Hardware or software applied calibration scale factor assumed
>   		to account for attenuation due to industrial design (glass
>   		filters or aperture holes).
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_sampling_period
> +KernelVersion:	3.5
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware dependent mode for proximity sensor device to set/get
> +		the sampling rate of proximity sensing and conversion.
Ah, that explains what it is.  Sorry, use 
in_proximitiy0_sampling_frequency to provide equivalent
control please.  Might be a pain here, but this interface will just 
provide the same info as the existing
one in a different form.  Note that sampling_frequency is documented as 
a general one, but can
be extended to individual channels.

Actually add it to the iio-core as an element in the info_mask as I 
doubt this will be the last time
we see this control. This will need to be a precursor patch to the 
driver obviously.

IIO_CHAN_INFO_SAMP_FREQ and the relevant shared and separate macros need 
to go in
iio.h + the text entry in industrialio-core.c

If you like I can do this but it'll be quicker if you do :)
