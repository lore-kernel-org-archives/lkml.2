Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab2GSWgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:36:08 -0400
Received: from toro.web-alm.net ([62.245.132.31]:58452 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab2GSWgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:36:03 -0400
Message-ID: <500888A6.4080702@osadl.org>
Date: Fri, 20 Jul 2012 00:22:30 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 1/1 v3] Honor state disabling in the cpuidle ladder governor
References: <201207192130.20520.rjw@sisk.pl> <20120719203409.398114351@osadl.org> <20120719204338.905308004@osadl.org> <201207192348.06045.rjw@sisk.pl>
In-Reply-To: <201207192348.06045.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 11:48 PM, Rafael J. Wysocki wrote:
> On Thursday, July 19, 2012, Carsten Emde wrote:
>> There are two cpuidle governors ladder and menu. While the ladder
>> governor is always available, if CONFIG_CPU_IDLE is selected, the
>> menu governor additionally requires CONFIG_NO_HZ.
>>
>> A particular C state can be disabled by writing to the sysfs file
>> /sys/devices/system/cpu/cpuN/cpuidle/stateN/disable, but this mechanism
>> is only implemented in the menu governor. Thus, in a system where
>> CONFIG_NO_HZ is not selected, the ladder governor becomes default and
>> always will walk through all sleep states - irrespective of whether the
>> C state was disabled via sysfs or not. The only way to select a specific
>> C state was to write the related latency to /dev/cpu_dma_latency and
>> keep the file open as long as this setting was required - not very
>> practical and not suitable for setting a single core in an SMP system.
>>
>> With this patch, the ladder governor only will promote to the next
>> C state, if it has not been disabled, and it will demote, if the
>> current C state was disabled.
>>
>> Note that the patch does not make the setting of the sysfs variable
>> "disable" coherent, i.e. if one is disabling a light state, then all
>> deeper states are disabled as well, but the "disable" variable does not
>> reflect it. Likewise, if one enables a deep state but a lighter state
>> still is disabled, then this has no effect. A related section has been
>> added to the documentation.
>>
>> Signed-off-by: Carsten Emde<C.Emde@osadl.org>
>
> This looks fine to me, but it's too late for v3.6.  I can queue it up
> for v3.7, though.
Yes, please.

Thanks,
	-Carsten.
