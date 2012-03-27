Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2C0Vfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:35:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43176 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2C0Vfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:35:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6662"; a="174041484"
Message-ID: <4F7232B3.7020504@codeaurora.org>
Date: Tue, 27 Mar 2012 14:35:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/6] firmware_class: Split _request_firmware() into three
 functions
References: <201203032122.36745.chunkeey@googlemail.com> <201203260001.46109.rjw@sisk.pl> <4F70B25E.60505@codeaurora.org> <201203262236.59126.rjw@sisk.pl>
In-Reply-To: <201203262236.59126.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/12 13:36, Rafael J. Wysocki wrote:
> On Monday, March 26, 2012, Stephen Boyd wrote:
>> On 03/25/12 15:01, Rafael J. Wysocki wrote:
>>> @@ -639,8 +655,15 @@ static int request_firmware_work_func(vo
>>>  		return 0;
>>>  	}
>>>  
>>> -	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
>>> +	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
>>> +	if (ret <= 0)
>>> +		return ret;
>> This needs to jump to the cont function so that users know loading
>> failed or that the firmware was builtin.
> You're right, sorry.  That should have been
>
> 	if (ret > 0) {
> 		ret = _request_firmware(fw, fw_work->name, fw_work->device,
> 			fw_work->uevent, true);
> 		if (ret)
> 			_request_firmware_cleanup(&fw);
> 	}
>
> but actually using a jump makes the next patch look better.
>
> Updated patch is appended.
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: firmware_class: Split _request_firmware() into three functions, v2
>
> Split _request_firmware() into three functions,
> _request_firmware_prepare() doing preparatory work that need not be
> done under umhelper_sem, _request_firmware_cleanup() doing the
> post-error cleanup and _request_firmware() carrying out the remaining
> operations.
>
> This change is requisite for moving the acquisition of umhelper_sem
> from _request_firmware() to the callers, which is going to be done
> subsequently.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

