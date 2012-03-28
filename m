Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2C1H7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:59:39 -0400
Received: from mga12.intel.com ([143.182.124.36]:42010 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752200Ab2C1H7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120326151147.30727745f5a3410d87f391dc@canb.auug.org.au>
References: <20120326151147.30727745f5a3410d87f391dc@canb.auug.org.au>
Date: Wed, 28 Mar 2012 00:59:36 -0700
Message-ID: <CABE8wwtqSC01O+DsjQp5U0shQh99e0vctHqRRY8e4OfxD+TaxA@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 9:11 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (sparc32 defconfig)
> produced these warnings (and many similar):
>
> In file included from drivers/scsi/hosts.c:41:0:
> drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM" is not defined [-Wundef]
> drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM_MODULE" is not defined [-Wundef]
>
> Introduced by commit a6a95fad44f1 ("scsi, sd: limit the scope of the
> async probe domain").

So, sparc does not source kernel/power/Kconfig or define config PM
locally.  Compiling out this list_head (scsi_sd_probe_domain) in the
!PM && !BLK_DEV_SD case may be more trouble then it is worth.  I'll
re-spin the patch without the IS_ENABLED conditionals.

--
Dan
