Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1HEP23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:28:29 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41005 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1HEP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:28:28 -0400
Date: Fri, 5 Aug 2011 10:26:40 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        hilld@binarystorm.net
Subject: Re: [PATCH v2] eCryptfs: fix compile error
Message-ID: <20110805152639.GA2607@boyd.l.tihix.com>
References: <1312198421-29989-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312198421-29989-1-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Aug 01, 2011 at 01:33:38PM +0200, Roberto Sassu <roberto.sassu@polito.it> wrote:
> This patch fixes the compile error reported at the address:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=40292
> 
> The problem arises when compiling eCryptfs as built-in and the 'encrypted'
> key type as a module. The patch prevents this combination from being set in
> the kernel configuration, by fixing the eCryptfs dependencies.

This patch does trick. Thanks, Roberto.

I'll get this applied and in a pull request soon.

Tyler

> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Reported-by: David Hill <hilld@binarystorm.net>
> ---
>  fs/ecryptfs/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
> index 1cd6d9d..cc16562 100644
> --- a/fs/ecryptfs/Kconfig
> +++ b/fs/ecryptfs/Kconfig
> @@ -1,6 +1,6 @@
>  config ECRYPT_FS
>  	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL && KEYS && CRYPTO
> +	depends on EXPERIMENTAL && KEYS && CRYPTO && (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
>  	select CRYPTO_ECB
>  	select CRYPTO_CBC
>  	select CRYPTO_MD5
> -- 
> 1.7.6
> 


