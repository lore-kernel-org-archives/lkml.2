Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1KMNIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:08:25 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36758 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1KMNIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:08:24 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4EBFC148.7070409@cam.ac.uk>
Date: Sun, 13 Nov 2011 13:08:24 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: drop "select IIO_SIMPLE_DUMMY_EVGEN"
References: <1321189545.20271.59.camel@x61.thuisdomein>
In-Reply-To: <1321189545.20271.59.camel@x61.thuisdomein>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2011 01:05 PM, Paul Bolle wrote:
> Commit e6477000fc ("staging:iio:dummy Add event support + fake event
> generator") added "select IIO_SIMPLE_DUMMY_EVGEN if [...]". But there
> is no Kconfig symbol named IIO_SIMPLE_DUMMY_EVGEN. The select statement
> for that symbol is a nop. Drop it.
Yes, you are quite right.  Looks like some dead logic from an earlier
version.  My mistake.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Jonathan Cameron <jic23@camd.ac.uk>
> ---
> 0) Tested with "make menuconfig" before and after applying this patch.
> Identical .config files were generated, as was expected.
> 
> 1) The "select IIO_DUMMY_EVGEN" of the IIO_SIMPLE_DUMMY_EVENTS Kconfig
> entry probably does what was intended here. Maybe that's why no one
> noticed.
Indeed it does.
> 
>  drivers/staging/iio/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
> index 4ec9118..90162aa 100644
> --- a/drivers/staging/iio/Kconfig
> +++ b/drivers/staging/iio/Kconfig
> @@ -76,7 +76,6 @@ config IIO_DUMMY_EVGEN
>  
>  config IIO_SIMPLE_DUMMY
>         tristate "An example driver with no hardware requirements"
> -       select IIO_SIMPLE_DUMMY_EVGEN if IIO_SIMPLE_DUMMY_EVENTS
>         help
>  	 Driver intended mainly as documentation for how to write
>  	 a driver. May also be useful for testing userspace code

