Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2JQKob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:44:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33723 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2JQKoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:44:30 -0400
Message-ID: <507E8C09.3060407@linaro.org>
Date: Wed, 17 Oct 2012 12:44:25 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: khilman@ti.com, len.brown@intel.com, g.trinabh@gmail.com,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        deepthi@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        akpm@linux-foundation.org, snanda@chromium.org
Subject: Re: [PATCH] cpuidle: reinitialize power_usage values when adding/removing
 C-states
References: <1350427184-11684-1-git-send-email-jwerner@chromium.org> <507E88F3.8070403@linaro.org>
In-Reply-To: <507E88F3.8070403@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 12:31 PM, Daniel Lezcano wrote:
> On 10/17/2012 12:39 AM, Julius Werner wrote:
>> When cpuidle drivers do not supply explicit power_usage values,
>> cpuidle/driver.c inserts dummy values instead. When a running processor
>> dynamically gains new C-states (e.g. after ACPI events), the power_usage
>> values of those states will stay uninitialized, and cpuidle governors
>> will never choose to enter them.
>>
>> This patch moves the dummy value initialization from
>> cpuidle_register_driver to cpuidle_enable_device, which drivers such as
>> acpi/processor_idle.c will call again when they add or remove C-states.
>> Tested and verified on an Acer AC700 Chromebook, which supports the C3
>> state only when it switches from AC to battery power.
>>
>> Signed-off-by: Julius Werner <jwerner@chromium.org>
>> ---
> This is specific to the acpi and should be handled in the
> processor_idle.c file instead of the cpuidle core code.
>
> Could be the function 'acpi_processor_cst_has_changed' the right place
> to set a dummy power value for the power in the new C-state ?

btw, good catch ! :)



-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


