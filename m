Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0IBIvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:51:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29863 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0IBIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:51:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6092"; a="53123482"
Message-ID: <4C7F6582.6060108@codeaurora.org>
Date: Thu, 02 Sep 2010 14:21:14 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Neil Leeder <nleeder@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hsin.Wu@quantatw.com, Horace Fu <horace.fu@quantatw.com>
Subject: Re: [PATCH 1/1] input: keyboard: add qci keyboard driver
References: <4C7838DD.1020004@codeaurora.org> <1282947517-32118-1-git-send-email-nleeder@codeaurora.org>
In-Reply-To: <1282947517-32118-1-git-send-email-nleeder@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 8/28/2010 3:48 AM, Neil Leeder wrote:
> +	__set_bit(EV_KEY, context->qcikbd_dev->evbit);
> +	__set_bit(EV_REP, context->qcikbd_dev->evbit);

If you are going to roll out new version of this patch to address the last
comment from Dmitry, then I have couple of suggestions. If possible
then please incorporate.

Make EV_REP optional, not all the systems needs it by default. Better to introduce
pdata->rep.

Some of the systems would need each key press to wake up the system, so
disable_irq in suspend would not be what they want. How about introducing
pdata->wakeup flag and then using device_init_wakeup, device_may_wakeup,
enable/disable_irq_wake friends in probe and .suspend/.resume functions.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
