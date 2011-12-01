Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1LAOTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:19:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1LAOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:19:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: add default value for PHYS_OFFSET Kconfig setting
Date: Thu, 1 Dec 2011 14:19:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011419.46751.arnd@arndb.de>
X-Provags-ID: V02:K0:PmKcPNgc2KOLTUbSQrR32DwNAH9N0MXf3rfl59u73kl
 VY9qUESPus2HSoAQSTCbcUPXEdLPklmsvDsSnqbCS/3yomt8ML
 eJ5PBs2x5n9YO4Q5C7yEfwE/SrVugJWSQitNy3FJc5OIAY5+Q4
 P4qM8c2UnxeRAxFb9MBXVyZxHw82kdPnOn0pa3V4P6k7jIpMPQ
 vrP+q3A7OgrQdxZReYl1afZlTziGKqPUVRWLP4cAvD60ffrI2D
 tPftEXv2Rbk8hE/myUp3L1HVFRZuv8E3HukQGCGp/H2J8FWfCU
 yg6eQXhs31x+/YzHnqjEWe+z612ehRM3hACUm5xA9SD+MUmVrW
 JIl7WGMg+o5aqOnkMR3M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 December 2011, Paul Gortmaker wrote:
> Commit 1b9f95f8ade9efc2bd49f0e7b9dc61a038ac3eef introduced the new
> Kconfig for PHYS_OFFSET but it did not specify a default value.
> 
> This has the undesired side effect of breaking an implictly used
> trick for updating defconfigs on the fly for routine buildtesting
> across all arch and all platforms, i.e.
> 
>   cp /path/to/somedefconfig .config ; yes "" | make oldconfig
> 

FWIW, a better way to achieve the above is using 

make KCONFIG_ALLCONFIG=/path/to/somedefconfig listnewconfig alldefconfig

which does not have this problem.

Your patch looks still ok, but you might want to update your scripts
to be more robust.

	Arnd
