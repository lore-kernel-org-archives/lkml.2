Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2GZAKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:10:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55829 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2GZAKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:10:10 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-82-50108ae09f07
Message-id: <50108AE0.5070502@samsung.com>
Date: Thu, 26 Jul 2012 09:10:08 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Implement button detection support
References: <1342800449-10328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <500F8DB4.30401@samsung.com>
 <20120725111105.GI3099@opensource.wolfsonmicro.com>
In-reply-to: <20120725111105.GI3099@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAd0HXQIBBi/vmVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M7m8vWAt+cFbMe76DsYGxmaOLkZNDQsBE4trnDkYIW0ziwr31
	bF2MXBxCAosYJTbv6mSCcLqYJNpubmMCqeIV0JI4ff4XWAeLgKrE12WzwGw2oPj+FzeAujk4
	RAUiJH71c0CUC0r8mHyPBSQsArTs9/1KkJHMAosZJf7seQDWKizgIXG7cxU7xK5VjBLdm2ew
	gyQ4BRwk5s/YxQJiMwvoSOxvncYGYctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgEHwmtYNxZYPFIUYBDkYlHl7PcIEAIdbEsuLK3EOMEhzMSiK8
	bulAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzG3l/9hQTSE0tSs1NTC1KLYLJMHJxSDYyakv5u
	hW2CroUvpnayuW5PCmV1Mndh5eCVF9djFbp7T9rqre/jS++6bgdd3mf65lvnnQeu4j+Tgi+e
	1P+qVrQ01+qt0aeLenb/lNPStqWt+Ryq8vih/J4tydYW4SfyJjF2pUjdzDtzsEx+y6WkjYek
	GH6HqhRka8Q1xIfMLuT3M8uX/d5yXImlOCPRUIu5qDgRACL8INY9AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 08:11 PM, Mark Brown wrote:

>> Why do you should report released event to all of buttons? I think that
>> you should only
>> report released event to previous pressed button. If user press two
>> button on the headset
>> at the same time and then user release only one button with pressed
>> another button, extcon-arizona driver have to report released event to
>> previous pressed button except for still pressed another button.
> 
> The input API already supresses duplicate reports, they won't be
> propagated to userspace, so there's no point in duplicating the work
> to remember what buttons are pressed in individual drivers.  Userspace
> will only see events reported that refect changes in state.


The extcon-arizona include six buttons(BTN_0, BTN_1, BTN_2, BTN_3,
BTN_4, BTN_5). Currently, extcon-arizona driver will report released
event to all buttons (BTN_0, BTN_1, BTN_2, BTN_3, BTN_4, BTN_5)
when released event irrespective of the type of buttons is happened.

If user press BTN_0 and BTN_1 at the same time and then user only
released BTN_0 but BTN_1 is still pressed, is it right that report
released event to all of buttons? I think that different event between
BTN_0 and BTN_1.

Thank you,
Chanwoo Choi


