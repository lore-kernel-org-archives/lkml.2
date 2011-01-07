Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1AGWP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:15:26 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55331 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab1AGWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:15:22 -0500
Message-ID: <4D279075.4080503@canonical.com>
Date: Fri, 07 Jan 2011 17:15:17 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nikolai Kondrashov <spbnick@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add evdev type and code definitions
References: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com> <4D278E6B.7020002@gmail.com>
In-Reply-To: <4D278E6B.7020002@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 05:06 PM, Nikolai Kondrashov wrote:
> On 01/08/2011 12:28 AM, Chase Douglas wrote:
>> +* BTN_TOOL_<name>:
>> +  - These codes are used in conjunction with input trackpads, tablets, and
>> +    touchscreens. These devices may be used with fingers, pens, or other tools.
>> +    When an event occurs and a tool is used, the corresponding BTN_TOOL_<name>
>> +    code should be set to a value of 1. When the tool is no longer interacting
>> +    with the input device, the BTN_TOOL_<name>  code should be reset to 0. All
>> +    trackpads, tablets, and touchscreens should use at least one BTN_TOOL_<name>
>> +    code when events are generated.
> 
> There are some tablets (namely UC-Logic ones), which do not indicate tool
> proximity. Yet they may have both a pen and a mouse. They just send reports
> with separate report IDs. Currently it is solved by using
> HID_QUIRK_MULTI_INPUT and not sending any BTN_TOOL_* events.
> 
> Should the documentation reflect the fact that some tablets do not send any
> BTN_TOOL_* events, or should the drivers be updated to synthesise them?

I think it should be stated more obviously that all evdev codes are
optional except for specific cases, such as BTN_TOUCH for any type of
touch device. My understanding is that BTN_TOOL_<name> is optional.

Perhaps I should do something like the following for all the evdev codes:

* <evdev code>:
  - Usage: Required|Optional|Required when ... etc.
  - <description>

> Note that in the latter case there will never be a BTN_TOOL_* with
> zero value when the tool leaves the digitizing area, but only when the tools
> are switched (if ever).

Hmm.. That seems incorrect to me. Why wouldn't it follow the behavior
outlined above?

-- Chase
