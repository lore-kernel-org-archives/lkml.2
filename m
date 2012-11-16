Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2KPPia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:38:30 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54654 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2KPPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:38:29 -0500
Message-ID: <50A65DF2.7010506@gmail.com>
Date: Fri, 16 Nov 2012 09:38:26 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of/fdt: NULL-terminate the root node path
References: <1353078878-13566-1-git-send-email-catalin.marinas@arm.com> <20121116151610.GF20103@arm.com>
In-Reply-To: <20121116151610.GF20103@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 09:16 AM, Catalin Marinas wrote:
> On Fri, Nov 16, 2012 at 03:14:38PM +0000, Catalin Marinas wrote:
>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Ah, this shouldn't have been here. git commit -c set the author as well.

I'll fix that and apply. Thanks.

Rob

> 
>> Commit 509b7455 (of/fdt: Don't copy garbage after "/" in root node path)
>> sets the path length to 0 to ignore any garbage after "/" in the root
>> node path. This has the side effect of also ignoring '\0' at the end of
>> the root node path. This patch sets the ignores the garbage by setting
>> the last character to '\0' and length to 1.
>>
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> ---
>>
>> The patch is against linux-next, not sure whether mainline will get the
>> same commit number. Please feel free to fold it into the original patch,
>> whichever is easier. Without this I can't boot arm64, doesn't populate
>> the platform devices.
>>
>>  drivers/of/fdt.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> index 73fb8c0..d9b2207 100644
>> --- a/drivers/of/fdt.c
>> +++ b/drivers/of/fdt.c
>> @@ -186,7 +186,8 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
>>  			 */
>>  			fpsize = 1;
>>  			allocl = 2;
>> -			l = 0;
>> +			l = 1;
>> +			*pathp = '\0';
>>  		} else {
>>  			/* account for '/' and path size minus terminal 0
>>  			 * already in 'l'
> 
