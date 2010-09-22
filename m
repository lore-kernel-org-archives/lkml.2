Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0IVBEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 21:04:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60080 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab0IVBEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:04:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C99564A.5000209@np.css.fujitsu.com>
Date: Wed, 22 Sep 2010 10:05:14 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/5] ACPI, APEI, HEST Fix the unsuitable usage of platform_data
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com> <1284865235-29920-4-git-send-email-ying.huang@intel.com> <20100921124308.GC18991@one.firstfloor.org>
In-Reply-To: <20100921124308.GC18991@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi
(2010/09/21 21:43), Andi Kleen wrote:
> On Sun, Sep 19, 2010 at 11:00:33AM +0800, Huang Ying wrote:
>> diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
>> index 343168d..1a3508a 100644
>> --- a/drivers/acpi/apei/hest.c
>> +++ b/drivers/acpi/apei/hest.c
>> @@ -137,20 +137,23 @@ static int hest_parse_ghes_count(struct acpi_hest_header *hest_hdr, void *data)
>>  
>>  static int hest_parse_ghes(struct acpi_hest_header *hest_hdr, void *data)
> 
> hest_hdr is a local variable on the stack.
> 
Yes, you are right. Exactly what hest_hdr pointed is ghes address of 
global static variable hest_tab.
> 
>> +
>> +	rc = platform_device_add_data(ghes_dev, &hest_hdr, sizeof(void *));
>> +	if (rc)
>> +		goto err;
> 
> Now you put the address of that local variable in some global data structure.
> 
> And then you likely return and later the access accesses random stack space? 
> 
No, I don't think so.

Here the value(ghes address) of hest_hdr is saved into the private area of ghes_dev,
not the address of hest_hdr itself. So what you described will not happen.

Best Regards,
Jin Dongming

> -Andi
> 
> 


