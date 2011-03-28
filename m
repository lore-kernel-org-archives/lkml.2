Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1C1SWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:22:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52986 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1C1SWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:22:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6299"; a="82527227"
Message-ID: <4D90D1DE.2030202@codeaurora.org>
Date: Mon, 28 Mar 2011 11:22:22 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: Remove possible deadlock from regulator_enable
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org> <1301326482-6547-2-git-send-email-collinsd@codeaurora.org> <20110328181151.GB28494@opensource.wolfsonmicro.com>
In-Reply-To: <20110328181151.GB28494@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 11:11 AM, Mark Brown wrote:

>> -/* locks held by regulator_enable() */
>> +/* Locks are *not* held by regulator_enable(). */
>>  static int _regulator_enable(struct regulator_dev *rdev)
>>  {
>> -	int ret, delay;
>> +	struct regulator_dev *supply_rdev = NULL;
>> +	int ret = 0, delay;
>>  
>> +	mutex_lock(&rdev->mutex);
> 
> This is going to be terribly confusing - the _ versions of the functions
> all by convention rely on their callers taking the mutex, allowing them
> to be safely used from internal APIs.  

_regulator_enable is only being called within regulator_enable and
_regulator_enable.  Would it remove the confusion to rename
_regulator_enable to something different?

-David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
