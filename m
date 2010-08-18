Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab0HRGMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:12:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41610 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0HRGL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IYUXZJJa60LZybmHtjqmkjaFTC1cF/e3KsZOZo+lCVEQMMi7Yi1QfLRnjcj3W/qxzC
         5uZVWcTe+hua5UJT6V6DDsyYXkhMuT7U+/z5AKO3LsJbrcmPGuaO/rQfmV7Oh1rrhZV1
         l4X1lkFWWm6XBBlhgbhaRu7XzrkYRfSruqY/s=
Message-ID: <4C6B79C8.7080602@gmail.com>
Date: Wed, 18 Aug 2010 08:12:24 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        stephan.diestelhorst@amd.com
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C6A6145.7020707@gmail.com> <201008171229.28917.stephan.diestelhorst@amd.com> <201008171251.29441.stephan.diestelhorst@amd.com> <4C6AA50F.3090801@gmail.com> <AANLkTin2XPHXL_o9hHz9f4beTYEx+isX+PaFRkMMiYHQ@mail.gmail.com>
In-Reply-To: <AANLkTin2XPHXL_o9hHz9f4beTYEx+isX+PaFRkMMiYHQ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 11:28 PM, Stephan Diestelhorst wrote:
> 2010/8/17 Tejun Heo <htejun@gmail.com>:
>> On 08/17/2010 12:51 PM, Stephan Diestelhorst wrote:
>>> I *think* I have applied the patch correctly. Please find a copy of
>>> "git show" in the build directory attached. This should be the right
>>> thing, shouldn't it?
>>
>>> Maybe I forgot to speify a particular debug option / verbosity?
>>
>>> I've also confirmed that the "XXX ahci_set_ipm" is present in
>>> libahci.ko. So either I've screwed up badly when compiling the initrd,
>>> the code is not executed or the printout does not make it into any
>>> logfile anymore.
>>
>> Yeah, that's weird.  You're enabling IPM, right?
> 
> Erm... Honestly, I have no clue. What is IPM? How do I enable it? This is a
> Kubuntu Lucid 10.04 distribution, and I have not touched too much. In
> particular, the kernels have been from upstream git, just with the Ubuntu config
> copied over.
> 
> Maybe it is just not enabled? I am guessing that IPM might be IDE power
> management? Or intelligent, integrated? Google turns up this email thread
> as one of the first hits and nothing else conclusive.

It's interface power management, also called link power management.
You can check whether it's enabled by

$ cat /sys/class/scsi_host/host0/link_power_management_policy

If it says max_performance, it's disabled.  If it says anything else,
it's enabled.

Thanks.

-- 
tejun
