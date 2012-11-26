Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2KZOJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:09:42 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:58605 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab2KZOJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:09:41 -0500
Message-ID: <50B3781E.3040205@compulab.co.il>
Date: Mon, 26 Nov 2012 16:09:34 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.7) Gecko/20121022 Thunderbird/10.0.7
MIME-Version: 1.0
To: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: Conditionally compile counter_32k
References: <1353922083-1094-1-git-send-email-alessio.bogani@elettra.trieste.it> <50B35A4D.8080501@compulab.co.il> <50B36B81.4010709@elettra.trieste.it>
In-Reply-To: <50B36B81.4010709@elettra.trieste.it>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/12 15:15, Alessio Igor Bogani wrote:
> Hi Igor,
> 
> On 26/11/2012 13:02, Igor Grinberg wrote:
>> On 11/26/12 11:28, Alessio Igor Bogani wrote:
> [...]
>>>   # Common support
>>> -obj-y := sram.o dma.o fb.o counter_32k.o
>>> +obj-y := sram.o dma.o fb.o
>>>   obj-m :=
>>>   obj-n :=
>>>   obj-  :=
>>>
>>> +obj-$(CONFIG_OMAP_32K_TIMER) += counter_32k.o
>>
>> We are moving away from this config option in favor of runtime detection,
> 
> Well, I'll be happy when it'll happen.
> 
>> Why do you need this?
> 
> Because until now the build system doesn't honour the config file. Indeed it builds that source code file also when I set CONFIG_OMAP_32K_TIMER to n.
> 
> The runtime detection isn't a good excuse for doesn't make the build system working like users expect.

So, the problem is the users expectations...
If you look, at Tony's omap-for-v3.8/timer branch,
patch: ARM: OMAP2+: timer: remove CONFIG_OMAP_32K_TIMER
it should change the expectations (at least I tried to do this in Kconfig file).

So, to the question of honoring the config option - yes,
but it is a work in progress on removing that one.

If you have a real issue that you are trying to fix - it is totally different thing,
but if it is just config option honoring... then I don't think we should merge this patch.

-- 
Regards,
Igor.
