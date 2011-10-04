Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab1JDPOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:14:18 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:45428 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab1JDPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:14:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E8B24BE.8060102@cam.ac.uk>
Date: Tue, 04 Oct 2011 16:22:38 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110930 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the  tree
References: <20111004175724.b253f03270f1067531e5d95d@canb.auug.org.au>
In-Reply-To: <20111004175724.b253f03270f1067531e5d95d@canb.auug.org.au>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/11 07:57, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the moduleh tree got a conflict in
> drivers/staging/iio/industrialio-ring.c between commit 14555b14455f
> ("staging:iio: replacing term ring with buffer in the IIO core") from the
> staging tree and commit 4903058fe223 ("staging: Add export.h for
> THIS_MODULE/EXPORT_SYMBOL to drivers/staging users") from the moduleh
> tree.
> 
> The former renamed the file modified by the latter.  The new file is
> drivers/staging/iio/industrialio-buffer.c and will need to include
> export.h.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 4 Oct 2011 17:48:56 +1100
> Subject: [PATCH] staging: Add export.h for EXPORT_SYMBOL to
>  drivers/staging/iio/industrialio-buffer.c
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Sorry Paul, I fear this going to keep happening.  Is there
a minimal set of patches Greg could pull into staging-next
to avoid more similar issues?
(assuming it isn't already all sorted out!)
> ---
>  drivers/staging/iio/industrialio-buffer.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-buffer.c b/drivers/staging/iio/industrialio-buffer.c
> index 4ce101a..628aa69 100644
> --- a/drivers/staging/iio/industrialio-buffer.c
> +++ b/drivers/staging/iio/industrialio-buffer.c
> @@ -14,6 +14,7 @@
>   * - Alternative access techniques?
>   */
>  #include <linux/kernel.h>
> +#include <linux/export.h>
>  #include <linux/device.h>
>  #include <linux/fs.h>
>  #include <linux/cdev.h>

