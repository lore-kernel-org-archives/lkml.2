Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab1FYLfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 07:35:39 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:15704 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1FYLfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 07:35:38 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5kzGuK2Unsg=
X-RZG-CLASS-ID: mo00
Message-ID: <4E05C808.3060609@hartkopp.net>
Date: Sat, 25 Jun 2011 13:35:36 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>, yinghai@kernel.org
CC: jbarnes@virtuousgeek.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] PCI: fix cardbus and sriov regressions
References: <1308561849-3223-1-git-send-email-linuxram@us.ibm.com> <4DFFB6B0.6090307@hartkopp.net> <4DFFB945.5090203@hartkopp.net> <20110620214127.GA22917@ram-laptop> <4DFFC2FC.5050502@hartkopp.net> <4E0353CA.7000708@hartkopp.net> <20110624192903.GM22917@ram-laptop>
In-Reply-To: <20110624192903.GM22917@ram-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.2011 21:29, Ram Pai wrote:
> On Thu, Jun 23, 2011 at 04:55:06PM +0200, Oliver Hartkopp wrote:
>> Hello RP,
>>
>> unfortunately i noticed the discussion on linux-kernel ML a bit late, as i did
>> not subscribe it due to the traffic.
> 
> sorry, did not see this mail earlier.
> 
> 
>>>>> When comparing the logs with mgdiff, i found
>>>>>
>>>>> in revered:
>>>>>
>>>>> pci_bus 0000:04: resource 0 [io  0x2000-0x20ff]
>>>>> pci_bus 0000:04: resource 1 [io  0x2400-0x24ff]
>>>>>
>>>>> in the fixed version (4 patches)
>>>>>
>>>>> pci_bus 0000:04: resource 0 [io  0x2400-0x24ff]
>>>>> pci_bus 0000:04: resource 1 [io  0x2001-0x2100]
>>
>> Did you get further with the unusual alignment?
> 
> No. i was thinking this alignment  should be ok, since that cardbus resource
> has to be SIZE aligned and not START aligned.
> 
> However if it is not acceptable, i will figure out a way
> to get it aligned on the right boundaries.

I'm not sure how drivers expect to access the register layouts of their
specific hardware. E.g. if you have a 32-bit register at the beginning of the
io resource and the driver accesses this with a 32-bit write operation, the
misalignment would be handled (by the CPU) very expensive at runtime, which is
definitely a big drawback in performance. I know the networking people
re-arranging structs to get less cycles in accessing data structures ...

I tried to understand the reason for the original commit in 3.0.0-rc1 that
broke my system - very ambitious :-)

But IMHO you should meet analogue starting boundaries as we had before to make
sure that you don't brake things on machines that did not show up yet.

Best regards,
Oliver
