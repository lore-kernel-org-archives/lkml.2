Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab0GHNOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:14:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59748 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab0GHNOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:14:46 -0400
Subject: Re: [RFC][PATCH] ima: add default rule for initramfs files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-ima-user@lists.sourceforge.net, Eric Paris <eparis@redhat.com>
In-Reply-To: <1278428902-27079-1-git-send-email-roberto.sassu@polito.it>
References: <1278428902-27079-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 09:14:43 -0400
Message-ID: <1278594883.3313.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 17:08 +0200, Roberto Sassu wrote:
> This patch modifies the default policy shipped with IMA, in order to avoid measurements
> of files in the initial ramdisk. Those files can be measured early in the boot process
> by the bootloader.
> The patch applies to latest version of the mainline kernel 2.6.35-rc4.

Yes, the initramfs measurements are therefore redundant, as they're
already included in the initramfs measurement, but perhaps, as the
number of initramfs is very limited and the individual file measurements
supplies additional information, it wouldn't hurt to keep the individual
file measurements as well.  These measurements could potentially help in
identifying initramfs changes.

Would appreciate other opinions before accepting this change.

thanks,

Mimi

> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/integrity/ima/ima_policy.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index aef8c0a..92d8d0e 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -64,6 +64,7 @@ static struct ima_measure_rule_entry default_rules[] = {
>  	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
>  	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
>  	{.action = DONT_MEASURE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
> +	{.action = DONT_MEASURE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
>  	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
>  	 .flags = IMA_FUNC | IMA_MASK},
>  	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,


