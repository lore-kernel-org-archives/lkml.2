Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0HBWNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:13:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14595 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0HBWNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:13:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6062"; a="49643814"
Message-ID: <4C5742FE.5040907@codeaurora.org>
Date: Mon, 02 Aug 2010 15:13:18 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org, rvaswani@codeaurora.org
Subject: CPU Hotplug add/remove optimizations
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

We are trying to use cpu hotplug to turn off a cpu when it is not in use 
to improve power management. I am trying to optimize the cpu hotplug add 
and cpu hotplug remove timings. Currently cpu hotplug add takes around 
250ms and cpu hotplug remove takes 190 ms. For the current purposes we 
want to assume that we are removing and adding the same core. It seems 
that since we are actually not replacing the core – there could be a lot 
of initialization overhead that could be saved and restored instead of 
calibrating the entire core again.
One such thing we have been looking at is that once a core is powered up 
during cpu hotplug add, it runs the calibrate_delay routine to calculate 
the value of loops_per_jiffy. In such a case could we bypass the 
calibrate_delay function and just save and restore the value of 
loops_per_jiffy?
Does this approach seem wrong to anyone?
Can we safely assume that the core will start at the same clock speed at 
which the value was stored and then restored? And thus keeping the value 
of loops_per_jiffy that we restored consistent with the rest of the system.
Does anyone else have other ideas to achieve better results?
I will be looking at implementing any solutions and advice and following 
up with metrics and results.

Thanks,
Rohit Vaswani

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

