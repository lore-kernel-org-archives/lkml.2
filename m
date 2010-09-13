Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0IMQXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:23:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8424 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0IMQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:23:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6105"; a="54302673"
Message-ID: <4C8E4FE7.4080808@codeaurora.org>
Date: Mon, 13 Sep 2010 09:23:03 -0700
From: Gregory Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: sx150x: fix error code value
References: <1284317845-5181-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1284317845-5181-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   	err = sx150x_i2c_read(chip->client, reg,&data);
>   	if (err>= 0)
> -		err = (data&  mask) != 0 ? 1 : 0;
> +		err = (data&  mask) != 0 ? -EIO : 0;
>

This doesn't work.  The IO pins are gpio data pins, which are used as 0 
or 1 data values (see sx150x_gpio_get).  Returning -EIO whenever an 
attempt is made to gpio_get_value on a non-zero gpio line will break things.

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
