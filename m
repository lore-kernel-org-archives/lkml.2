Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab1FWOzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:55:10 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:34182 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab1FWOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:55:09 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzAuK6Yfw==
X-RZG-CLASS-ID: mo00
Message-ID: <4E0353CA.7000708@hartkopp.net>
Date: Thu, 23 Jun 2011 16:55:06 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: yinghai@kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] PCI: fix cardbus and sriov regressions
References: <1308561849-3223-1-git-send-email-linuxram@us.ibm.com> <4DFFB6B0.6090307@hartkopp.net> <4DFFB945.5090203@hartkopp.net> <20110620214127.GA22917@ram-laptop> <4DFFC2FC.5050502@hartkopp.net>
In-Reply-To: <4DFFC2FC.5050502@hartkopp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello RP,

unfortunately i noticed the discussion on linux-kernel ML a bit late, as i did
not subscribe it due to the traffic.

Did you get further with the unusual alignment?

Even if i did not see any problems (i did not test the CardBus slot but only
the sdhci_pci), i wonder if the register layout of some adapters would get
into problems with this alignment shown below?!?

Regards,
Oliver

ps. pls put me in CC in the next patch servies. tnx

On 21.06.2011 00:00, Oliver Hartkopp wrote:

>>>
>>> When comparing the logs with mgdiff, i found
>>>
>>> in revered:
>>>
>>> pci_bus 0000:04: resource 0 [io  0x2000-0x20ff]
>>> pci_bus 0000:04: resource 1 [io  0x2400-0x24ff]
>>>
>>> in the fixed version (4 patches)
>>>
>>> pci_bus 0000:04: resource 0 [io  0x2400-0x24ff]
>>> pci_bus 0000:04: resource 1 [io  0x2001-0x2100]
>>>
>>> Don't you think that the ressource 0x2001-0x2100 looks a bit weird?
>>>
>>> off-by-one problem?
>>
>> The resource location has slid by 1. That is because a reassign of
>> resource unfortunately does not let me realign it at the same location.
>>
>> ALIGN() macro is causing that weirdness.
>>
>> However is that slide by 1 causing you any problem?
> 
> No. I don't have a PCMCIA card here to test but the SD-Card is working
> properly. I just wondered about the unusual alignment ...

