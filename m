Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0KKMA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:00:29 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11216 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0KKMA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:00:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6163"; a="61484711"
Message-ID: <4CDBDAD5.90406@codeaurora.org>
Date: Thu, 11 Nov 2010 17:30:21 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC v1 PATCH 4/6] input: pmic8058_pwrkey: Add support for power
 key
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-5-git-send-email-tsoni@codeaurora.org> <20101111072107.GA24415@core.coreip.homeip.net>
In-Reply-To: <20101111072107.GA24415@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 11/11/2010 12:51 PM, Dmitry Torokhov wrote:
> Hi Trilkok,
> 
> On Wed, Nov 10, 2010 at 06:17:59PM +0530, Trilok Soni wrote:
>> Add support for PMIC8058 power key driven over dedicated
>> KYPD_PWR_N pin. It allows the user to specify the amount
>> of time by which the power key reporting can be delayed.
>>
> 
> Why do we need to delay KEY_POWER reporting? Do we need to use high
> resolution timers or regular timers would do as well? KEY_END appears to
> be abused (you don't want to move your cursor to the end of line, do
> you?). Also I wonder if header file should reside in linux/mfd with the
> rest of pmic8058 components.

Most of the time Mobile devices come with single physical key for POWER,
which if pressed for less than 500ms (configurable) then it will only
report KEY_END (which say locks the screen on mobile) and if it pressed
more than 500ms then it will also report KEY_POWER event too, which will
say display menu on your mobile for asking you to suspend/switch off/etc, operations.

For the timers I can move from hrtimers to regular timers.

For the header file, I can move them to include/linux/mfd too. No problem on that.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
