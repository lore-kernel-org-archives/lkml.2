Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2CMQ0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:26:36 -0400
Received: from canardo.mork.no ([148.122.252.1]:58137 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab2CMQ0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:26:35 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        "Fry\, Donald H" <donald.h.fry@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [34-longterm 098/196] iwlagn: Support new 5000 microcode.
Organization: m
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
	<1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
	<1331598109-31424-53-git-send-email-paul.gortmaker@windriver.com>
Date: Tue, 13 Mar 2012 17:24:42 +0100
In-Reply-To: <1331598109-31424-53-git-send-email-paul.gortmaker@windriver.com>
	(Paul Gortmaker's message of "Mon, 12 Mar 2012 20:20:11 -0400")
Message-ID: <87k42olb91.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

> From: "Fry, Donald H" <donald.h.fry@intel.com>
>
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
>
> commit 41504cce240f791f1e16561db95728c5537fbad9 upstream.
>
> New iwlwifi-5000 microcode requires driver support for API version 5.
>
> Signed-off-by: Don Fry <donald.h.fry@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
> index d05fad4..dc191b8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
> @@ -48,7 +48,7 @@
>  #include "iwl-6000-hw.h"
>  
>  /* Highest firmware API version supported */
> -#define IWL5000_UCODE_API_MAX 2
> +#define IWL5000_UCODE_API_MAX 5
>  #define IWL5150_UCODE_API_MAX 2

This looks like the patch which broke the driver in stable-2.6.32.y and
was later reverted by:


commit 2a96ae707525ef00a85bf374e56f0219c07eac5a
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Wed Jun 15 13:12:35 2011 -0700

    Revert "iwlagn: Support new 5000 microcode."
    
    This reverts commit 6f63415fc1b690cb50c2ad48ba6e9e6e88e271b4.
    
    It turns out this is not what we want to have happen for the .32 and
    .33-longterm kernels as it does not work properly at all.
    
    This was reported by Gentoo, Arch, and Canonical developers as causing
    problems for their users:
        https://bugs.archlinux.org/task/24302
        http://bugs.gentoo.org/show_bug.cgi?id=359445
        https://bugs.launchpad.net/ubuntu/+source/linux/+bug/796336
    
    Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    Cc: Gordon Malm <gengor@gentoo.org>
    Cc: Don Fry <donald.h.fry@intel.com>
    Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
    Cc: Stanislaw Gruszka <sgruszka@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>




Bjørn
