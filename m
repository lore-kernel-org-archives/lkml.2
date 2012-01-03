Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2ACWdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:33:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42694 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2ACWdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:33:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6578"; a="151947222"
Message-ID: <4F03821D.9080503@codeaurora.org>
Date: Tue, 03 Jan 2012 14:33:01 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: linux-arm-kernel@lists.infradead.org, Ben Hutchings <ben@decadent.org.uk>,
        Olof Johansson <olofj@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH] ARM: Remove BUILD_BUG_ON from asm/bug.h
References: <1325616276-10304-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1325616276-10304-1-git-send-email-sjg@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/12 10:44, Simon Glass wrote:
> BUILD_BUG_ON is defined in linux/kernel.h but that is not included by the
> asm/bug.h header which uses it. This causes a build error:
>
> ...include/linux/mtd/map.h: In function 'inline_map_read':
> ...include/linux/mtd/map.h:408:3: error: implicit declaration of function
> 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]
>
> The check is not essential and is not present for other architectures, so
> just remove it.

I thought this check was put in place to catch changes to struct
bug_entry being out of sync with the __BUG macro defined in ARM. Why
can't we include kernel.h instead? Or can you elaborate some more on why
we don't need this check in the commit text?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

