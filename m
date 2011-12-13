Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1LMJ0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:26:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:52310 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1LMJ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:26:30 -0500
Message-ID: <4EE71A62.9050700@oracle.com>
Date: Tue, 13 Dec 2011 17:26:58 +0800
From: liang tang <liang.tang@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stefan.bader@canonical.com,
        Ian.Campbell@citrix.com, mike.mcclurg@citrix.com, jeremy@goop.org,
        ke.yu@intel.com, kevin.tian@intel.com, konrad@kernel.org,
        lenb@kernel.org, xen-devel@lists.xensource.com, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 5/8] ACPI: add processor driver for Xen virtual
 CPUs.
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com> <1322673664-14642-6-git-send-email-konrad.wilk@oracle.com> <4ED755D70200007800064987@nat28.tlf.novell.com> <20111212172941.GA8619@phenom.dumpdata.com> <4EE710A00200007800067274@nat28.tlf.novell.com>
In-Reply-To: <4EE710A00200007800067274@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EE71A3A.0064,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-13 15:45, Jan Beulich wrote:
>>>> On 12.12.11 at 18:29, Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>  wrote:
>> On Thu, Dec 01, 2011 at 09:24:23AM +0000, Jan Beulich wrote:
>>>>>> On 30.11.11 at 18:21, Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>  wrote:
>>>> --- a/drivers/acpi/Makefile
>>>> +++ b/drivers/acpi/Makefile
>>>> @@ -66,6 +66,7 @@ obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
>>>>   # processor has its own "processor." module_param namespace
>>>>   processor-y			:= processor_driver.o processor_throttling.o
>>>>   processor-y			+= processor_idle.o processor_thermal.o
>>>> +processor-y			+= processor_xen.o
>>> This should minimally be processor-$(CONFIG_XEN), with other things
>>> adjusted as necessary.
>> I was under the impression that this was required to get the
>> processor_xen.ko
>> to be a module. Otherwise it would only compile as built-in.
> processor_xen.ko? Why not have all the code go into processor.ko?
> (And the original construct didn't aim in that direction either.)
>
> Jan
>
the code about driver function which kernel 
require(drivers/acpi/processor_xen.c )  build into processor.ko.
the code which have more relation with xen 
(drivers/xen/acpi_processor.c)  did not build into processor.ko.
liang
