Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1BRKdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:33:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58658 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BRKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:33:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 11/12] unicore32 machine related files: ps2 driver
Date: Fri, 18 Feb 2011 11:33:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, "'Greg KH'" <greg@kroah.com>
References: <015701cbcdae$7d5f43f0$781dcbd0$@mprc.pku.edu.cn> <201102171803.15785.arnd@arndb.de> <00eb01cbcf56$9f372700$dda57500$@mprc.pku.edu.cn>
In-Reply-To: <00eb01cbcf56$9f372700$dda57500$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181133.26675.arnd@arndb.de>
X-Provags-ID: V02:K0:IwOPkgBrbla30uYVbns1LndhdteqFFmz5DpYaZ6lHNg
 E7FegdIi+NWCUx/MT2fpii8WD5m+rkEJNjIqpdFYYJq1+tUlk5
 Lo3Qk02Gao9MthV0Z0WmJbprSS07UPvGrrfi6Zy3DLUnxW/el3
 KOTi4PoiULp5dvG8CJ96/cOcwhdnd3j10vTa7pwoAjRJAJ//QY
 dHOBullM9VkTfFeTRstHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 February 2011 11:28:45 Guan Xuetao wrote:
>   * Register numbers.
>   */
> -#define I8042_COMMAND_REG      ((unsigned long)&PS2_COMMAND)
> -#define I8042_STATUS_REG       ((unsigned long)&PS2_STATUS)
> -#define I8042_DATA_REG         ((unsigned long)&PS2_DATA)
> +#define I8042_COMMAND_REG      ((volatile void __iomem *)&PS2_COMMAND)
> +#define I8042_STATUS_REG       ((volatile void __iomem *)&PS2_STATUS)
> +#define I8042_DATA_REG         ((volatile void __iomem *)&PS2_DATA)
> +
> +#define I8042_REGION_START     (resource_size_t)(&PS2_DATA)
> +#define I8042_REGION_SIZE      (resource_size_t)(16)

It would be better to remove the cast and make the PS2_COMMAND
etc macros have the correct type. Aside from this, the change
looks good.

	Arnd
