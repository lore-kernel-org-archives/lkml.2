Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab2ALOrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:47:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2ALOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:47:00 -0500
Message-ID: <4F0EF253.7050308@gmail.com>
Date: Thu, 12 Jan 2012 06:46:43 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: "R, Durgadoss" <durgadoss.r@intel.com>,
        "linux-x86_64@vger.kernel.org" <linux-x86_64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CPU clock throttled prints..
References: <D6D887BA8C9DFF48B5233887EF04654109E855E9B4@bgsmsx502.gar.corp.intel.com> <4F0E4147.7000903@linux.intel.com>
In-Reply-To: <4F0E4147.7000903@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 06:11 PM, Chen Gong wrote:
> 于 2011/7/5 13:36, R, Durgadoss 写道:
>> Hi All,
>>
>> I am getting these prints in my Atom based device, running 2.6.35 kernel.
>>
>> [ 350.084005] CPU0: Temperature above threshold, cpu clock throttled
>> (total
>> events = 26)
>> [ 350.084029] CPU1: Temperature above threshold, cpu clock throttled
>> (total
>> events = 26)
>> [ 350.085293] CPU0: Temperature/speed normal
>> [ 350.085311] CPU1: Temperature/speed normal
>>
>> Seems like these are from therm_throt.c and the flow for this,
>> Starts from smp_thermal_interrupt(...) method.
>>
>> Can somebody tell me when this method gets called ?
>> Also, does this actually throttle the CPU ?
>>
>
> try to apply this patch 29e9bf1841e4f (x86, mce, therm_throt: Don't report
> power limit and package level thermal throttle events in mcelog)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-x86_64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

probably not the best solution, but I just ended up disabling the 
function in the kernel: (either its below or its under a different name)
X86_MCE_INTEL = n

this way when I watch hulu, dmesg is not spammed with something about 
"above threshold" by just watching a movie.

Justin P. Mattock
