Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2HHPlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:41:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47364 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2HHPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:41:01 -0400
Message-ID: <50228889.5060709@wwwdotorg.org>
Date: Wed, 08 Aug 2012 09:40:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Takashi Iwai <tiwai@suse.de>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH 11/11] pm/drivers: fix use of SIMPLE_DEV_PM_OPS
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-12-git-send-email-arnd@arndb.de>
In-Reply-To: <1344437248-20560-12-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 08:47 AM, Arnd Bergmann wrote:
> A few drivers use a construct like
> 
>  #ifdef CONFIG_PM
>  static int foo_suspend(struct device *pdev)
>  {
>     ...
>  }
>  static int foo_resume struct device *pdev)
>  {
>     ...
>  }
>  #endif
>  static SIMPLE_DEV_PM_OPS(foo_pm, foo_suspend, foo_resume);
...
> drivers/i2c/busses/i2c-tegra.c:716:12: warning: 'tegra_i2c_suspend' defined but not used [-Wunused-function]
> drivers/i2c/busses/i2c-tegra.c:727:12: warning: 'tegra_i2c_resume' defined but not used [-Wunused-function]

Laxman already posted a patch for this, which I'm hoping will make it
into 3.6, through the I2C tree.

http://www.spinics.net/lists/linux-i2c/msg09359.html
