Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2ADROw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:14:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48978 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2ADROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:14:50 -0500
Message-ID: <4F048905.5060004@lwfinger.net>
Date: Wed, 04 Jan 2012 11:14:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: John W Linville <linville@tuxdriver.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8192cu: Fix WARNING on suspend/resume
References: <4f034b6c.ypfAbSdXSgMHtfqa%Larry.Finger@lwfinger.net> <CALSq=BaJSURcKU8RkCxxG=Mht4y04dVefKMESuHmiEdhwzc2Eg@mail.gmail.com>
In-Reply-To: <CALSq=BaJSURcKU8RkCxxG=Mht4y04dVefKMESuHmiEdhwzc2Eg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 10:16 AM, Daniel Halperin wrote:
> Sorry, Larry, I didn't see this til it was included in John's mail this morning.
>
> On Tue, Jan 3, 2012 at 10:39 AM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>
>> +#ifdef CONFIG_PM
>> +static int rtl8192cu_usb_suspend(struct usb_interface *pusb_intf,
>> +                                pm_message_t message)
>> +{
>> +       /* Increase usage_count to Save loaded fw across suspend/resume */
>> +       atomic_inc(&usage_count);
>> +       return 0;
>> +}
>> +
>> +static int rtl8192cu_usb_resume(struct usb_interface *pusb_intf)
>> +{
>> +       atomic_dec(&usage_count);       /* after resume, decrease usage count */
>> +       return 0;
>> +}
>> +#endif
>
> Based on the warning-fix I submitted yesterday, this probably produces
> a warning if CONFIG_PM is set but not CONFIG_PM_SLEEP. My patch was
> for an ethernet driver, but iwlwifi and ath5k appear to follow the
> same pattern using CONFIG_PM_SLEEP instead of the above.
>
> See: http://www.spinics.net/lists/netdev/msg184717.html for the patch
> and http://www.spinics.net/lists/netdev/msg184715.html for the
> discussion.

Thanks for the note. I will prepare a revised patch.

What architecture gave the warning? Of x86_64, I was unable to get 
CONFIG_PM_SLEEP without CONFIG_PM.

Larry

