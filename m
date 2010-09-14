Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0INITL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:19:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49556 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab0INITH (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Tue, 14 Sep 2010 04:19:07 -0400
Message-Id: <4C8F4C400200007800015EC7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 14 Sep 2010 09:19:44 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Chen Gong" <gong.chen@linux.intel.com>
Cc: <fenghua.yu@intel.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] x86/hwmon: fix module init for
	 hotplug-but-no-device-found case
References: <4C8E139F0200007800015AA5@vpn.id2.novell.com>
 <4C8F167E.40506@linux.intel.com>
 <4C8F36B40200007800015E6B@vpn.id2.novell.com>
 <4C8F2863.5070003@linux.intel.com>
In-Reply-To: <4C8F2863.5070003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.09.10 at 09:46, Chen Gong <gong.chen@linux.intel.com> wrote:
> 于 9/14/2010 2:47 PM, Jan Beulich 写道:
>>>>> On 14.09.10 at 08:30, Chen Gong<gong.chen@linux.intel.com>  wrote:
>>> 于 9/13/2010 6:05 PM, Jan Beulich 写道:
>>>> In commit 0dca94baeab4a1a514841b0a4c8e3a51dfb4d5ae the call to
>>>> platform_driver_unregister() was made conditional upon !HOTPLUG_CPU,
>>>> but the return value from coretemp_init() was left to indicate an
>>>> error. This isn't correct, as the negative return value indicates to
>>>> the module loader that initialization failed, which isn't intended
>>>
>>> only !HOTPLUG_CPU can remove the driver. That is what we need to do
>>> because under the hotplug condition, we need to consider those "offline"
>>> cpus. I don't understand what you are afraid. Can you give me a scinario ?
>>
>> If the driver's init routine returns -ENODEV (like is the case without this
>> change when HOTPLUG_CPU is enabled and there is no device found),
>> the platform driver will remain registered, yet the driver memory will
>> get freed (leaving dangling pointers into the driver's former image). Or
> 
> Under this condition, I can't fine who frees the memory of the platform
> driver

I'm not talking about the control structure, but about the driver's
code and data.

>> in other words - when leaving the driver registered, the return value
>> of the init function must be zero.
> 
> Is it mandotary or just some kind of convention ?

Mandatory.

Jan
