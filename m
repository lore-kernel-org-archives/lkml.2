Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0ELOJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0ELOJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:09:39 -0400
Message-ID: <4BEAB683.8040600@redhat.com>
Date: Wed, 12 May 2010 10:09:07 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
       gpxe-devel@etherboot.org
Subject: Re: [PATCH 1/2] ibft: Update iBFT handling for v1.03 of the spec.
References: <1270822888-13192-1-git-send-email-konrad@kernel.org> <1270822888-13192-2-git-send-email-konrad@kernel.org> <alpine.LFD.2.00.1005120125170.5297@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005120125170.5297@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 01:26 AM, Len Brown wrote:
> 
>>  #define IBFT_SIGN "iBFT"
> ...
>> +#ifdef CONFIG_ACPI
>> +	/*
>> +	 * One spec says "IBFT", the other says "iBFT". We have to check
>> +	 * for both.
>> +	 */
> 
> Really?
> Which one do you see in the field?

Well, we haven't seen any ACPI-based hardware yet AFAIK - but I'm supposed to
have some soon.  So it's too early to tell which one is actually going to be
the more common case, or if this is really a non-issue.

> any reason to #define "iBFT" above and not use it below?

Nope, that's just an error.  I'll send a patch.

> 
>> +	if (!ibft_addr)
>> +		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
>> +	if (!ibft_addr)
>> +		acpi_table_parse("iBFT", acpi_find_ibft);
>> +#endif /* CONFIG_ACPI */
> 
> Len Brown, Intel Open Source Technology Center


-- 
        Peter

Obviously, a major malfunction has occurred.
		-- Steve Nesbitt, voice of Mission Control, January 28, 1986
