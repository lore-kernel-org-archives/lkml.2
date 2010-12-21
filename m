Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab0LURdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:33:14 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37705 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0LURdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:33:11 -0500
Message-ID: <4D10E4B6.8070003@canonical.com>
Date: Tue, 21 Dec 2010 12:32:38 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: synaptics - add multi-finger and semi-mt support
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se> <1292852364-19127-3-git-send-email-rydberg@euromail.se> <4D10D75D.80400@canonical.com> <20101221165956.GA28702@polaris.bitmath.org>
In-Reply-To: <20101221165956.GA28702@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 11:59 AM, Henrik Rydberg wrote:
>>> Reported-by: Tobyn Bertram
>>> Not-yet-signed-off-by: Takashi Iwai <tiwai@suse.de>
>>> Not-yet-signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>>> Not-yet-signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
>>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>>
>> You can keep my SOB.
> 
> Great, thanks.
>  
>>> +static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
>>> +{
>>> +	input_mt_slot(dev, slot);
>>> +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
>>> +	if (active) {
>>> +		input_report_abs(dev, ABS_MT_POSITION_X, x);
>>> +		input_report_abs(dev, ABS_MT_POSITION_Y,
>>> +				 YMAX_NOMINAL + YMIN_NOMINAL - y);
>>> +	}
>>> +}
>>
>> I take it that you feel MT_TOOL_FINGER should always be set, even if
>> it's always the same as BTN_TOOL_*? I just want to be sure this is
>> intended so we document it appropriately.
> 
> Yes - the MT_TOOLs are only emitted when explicitly set in absbit, but
> the internal interface always handles it. This is actually documented
> in the code (and DocBook).

Ahh, I had forgotten about this.

>>> @@ -623,6 +686,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>>>  	int i;
>>>  
>>>  	__set_bit(INPUT_PROP_POINTER, dev->propbit);
>>> +	__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>>
>> Shouldn't this only be set when SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) is
>> true?
> 
> Indeed - thanks.

All looks good to me with this change :). Thanks again!

-- Chase
