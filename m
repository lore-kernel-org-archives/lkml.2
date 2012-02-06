Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2BFK5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 05:57:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2BFK5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 05:57:20 -0500
Date: Mon, 6 Feb 2012 10:57:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: hauke@hauke-m.de, kernel-team@lists.ubuntu.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compat: add compat kernel checker and downloader
Message-ID: <20120206105717.GB15655@shadowen.org>
References: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 03:43:14PM -0800, Luis R. Rodriguez wrote:
> This adds get-compat-kernels, a utility that is intended
> to be Linux distribution agnostic that downloads and installs
> all kernel headers for all supported kernel releases of compat.
> You also have the option of specifying you want to also install
> the actual kernel image (get-compat-kernels -i).
> 
> We start off by adding support for Ubuntu on x86_64 as that
> is what a few of us maintaining compat and compat-wireless run.
> Just for kernel headers (default run of get-compat-kernels),
> you'll need currently 205 M of hard drive space.
> 
> Once done with running get-compat-kernels, you can then
> start running ckmake to verify your compat kernel changes
> won't bust compilation against any known supported kernel.

This sounds like very reasonable plan.

[...]
> +	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
> +	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624-generic_2.6.24-020624_amd64.deb"
> +	KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-image-2.6.24-020624-generic_2.6.24-020624_amd64.deb"

If its any help, the snippet below is how we encode the official version
number as the abi number, the base version is always the first three
digits of the version.  It might let you turn this into a list of
versions:

abinum=`echo "$abinum" | awk -F'[.-]' '{
        for (i = 1; i <= NF; i++) {
                if ($i ~ /^[0-9][0-9]*$/) {
                        printf("%02d", $i);
                } else {
                        printf("%s", $i);
                }
        }
}'`

-apw
