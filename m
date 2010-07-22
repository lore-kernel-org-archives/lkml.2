Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab0GVRWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:22:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54657 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0GVRWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:22:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48303553"
Message-ID: <4C487E62.9080106@codeaurora.org>
Date: Thu, 22 Jul 2010 10:22:42 -0700
From: Greg Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: akpm@linux-foundation.org, david-b@pacbell.net, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] gpio: sx150x: Add Semtech I2C sx150x gpio expander
 driver.
References: <1279818771-9428-1-git-send-email-gbean@codeaurora.org> <20100722101753.c73604eb.randy.dunlap@oracle.com>
In-Reply-To: <20100722101753.c73604eb.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >> +	bool "Semtech SX150x I2C GPIO expander"
 >> +	depends on I2C=y
 >> +	default n
 >> +	help
 >> +	  Say yes here to provide support for Semtech SX150-series I2C
 >> +	  GPIO expanders. Compatible models include:
 >
 > Just curious, not complaining, but why does this driver (and some others)
 > need to be built-in instead of having the option of being built as a
 > loadable module?

It's that way because it requires unexported symbols from genirq and 
I2C.  If this driver is allowed to be a module, it can't find the 
unexported genirq symbols, and if I2C is allowed to be a module, then a 
bunch of i2c_smbus stuff can't be resolved...

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
