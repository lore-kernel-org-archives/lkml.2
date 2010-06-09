Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab0FISKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:10:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60751 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab0FISJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:09:59 -0400
Message-ID: <4C0FD883.8040605@oracle.com>
Date: Wed, 09 Jun 2010 11:08:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for June 9 (niu)
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>	<20100609103657.66252a27.randy.dunlap@oracle.com> <20100609.110638.112605100.davem@davemloft.net>
In-Reply-To: <20100609.110638.112605100.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C0FD8F0.004D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/10 11:06, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Wed, 9 Jun 2010 10:36:57 -0700
> 
>> On Wed, 9 Jun 2010 13:34:43 +1000 Stephen Rothwell wrote:
>>
>>> Changes since 20100608:
>>>
>>> My fixes tree contains:
>>>       v4l-dvb: update gfp/slab.h includes
>>>       arm: update gfp/slab.h includes
>>>       davinci: update gfp/slab.h includes
>>>       ocfs2: update gfp/slab.h includes
>>>       acpi: update gfp/slab.h includes
>>
>>
>>
>> on x86_64 or i386, CONFIG_OF_DEVICE is not enabled:
>>
>> drivers/net/niu.c:9700: warning: 'struct of_device' declared inside parameter list
>> drivers/net/niu.c:9700: warning: its scope is only this definition or declaration, which is probably not what you want
>> drivers/net/niu.c:9716: warning: assignment from incompatible pointer type
> 
> Hmmm, I'm confused why this never happened before :-)
> 
> We conditionalize linux/of_device.h inclusion with CONFIG_SPARC64, yet
> we unconditionally use "struct of_device *" pointers in the driver
> with no such ifdef protection.
> 
> Even if we unconditionally included linux/of_device.h, that file does
> nothing unless CONFIG_OF_DEVICE is defined so it should have always
> produced these warnings since I can't see from where else it could
> have gotten even a "struct of_device;" somewhere.
> 
> Do you have any idea Randy?  Pease try analyze this further so we can
> fix it properly.


I looked and was confuzed, but I'll look again.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
