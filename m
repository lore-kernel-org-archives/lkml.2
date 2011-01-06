Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1AFQbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:31:14 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:36297 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1AFQbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dQy0IxhokTZ7XFQW+WfbaAZHsEIs//dcis1+CBHpK+qUjofvA7VTACCOSQZsoKzlrW
         +LkoBK2Gc8b6zzRBEjJKNanAGi9WjWnvDAcDzcJCETXW01uChPGLRtQTlvP6jKQeCtyY
         araGgp5eGi0eg2EMKg/Id/kN/rYA3vl0H/iiA=
Message-ID: <4D25EE4A.9010602@gmail.com>
Date: Thu, 06 Jan 2011 17:31:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/1] PM: fix oops in suspend/hibernate code
References: <201101060028.43342.rjw@sisk.pl> <1294305504-5787-1-git-send-email-jslaby@suse.cz> <201101061657.39723.rjw@sisk.pl> <4D25E943.804@gmail.com>
In-Reply-To: <4D25E943.804@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 05:09 PM, Jiri Slaby wrote:
>>> --- a/kernel/power/nvs.c
>>> +++ b/kernel/power/nvs.c
>>> @@ -105,7 +105,7 @@ int suspend_nvs_alloc(void)
>>>  /**
>>>   *	suspend_nvs_save - save NVS memory regions
>>>   */
>>> -void suspend_nvs_save(void)
>>> +int suspend_nvs_save(void)
>>>  {
>>>  	struct nvs_page *entry;
>>>  
>>> @@ -114,8 +114,14 @@ void suspend_nvs_save(void)
>>>  	list_for_each_entry(entry, &nvs_list, node)
>>>  		if (entry->data) {
>>>  			entry->kaddr = ioremap(entry->phys_start, entry->size);
>>
>> I wonder what happens if you simply change the ioremap() here to
>> ioremap_nocache() without any other modifications?
> 
> ioremap *is* ioremap_nocache on x86. And that's the conflict it
> complains about I guess? Don't you mean ioremap_cache?

Using ioremap_cache indeed fixes the problem...

thanks,
-- 
js
