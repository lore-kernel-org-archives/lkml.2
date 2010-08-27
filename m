Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab0H0Bip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:38:45 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:49474 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab0H0Bin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:38:43 -0400
Message-ID: <4C77171E.6060008@cesarb.net>
Date: Thu, 26 Aug 2010 22:38:38 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>
In-Reply-To: <1282869660.1836.5.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-08-2010 21:41, Joe Perches escreveu:
> On Thu, 2010-08-26 at 21:11 -0300, Cesar Eduardo Barros wrote:
>> Em 26-08-2010 20:33, Joe Perches escreveu:
>>> On Thu, 26 Aug 2010, Cesar Eduardo Barros wrote:
>>>> On my Dell Inspiron N4010, one of these messages is printed every five
>>>> seconds. Change both to dev_dbg to quieten them even more.
>>> I think you should instead fix your hardware or maybe change
>>> your thermal throttling settings.
>
> I was probably a bit hasty in writing that.
>
>> Is there a way to know if all this is just an oddness of this model, or
>> if there is something which is not working quite right?
>>
>> (All the output above is from 2.6.35.3; I am not running 2.3.36-rc2+
>> right now because it hangs on resume, and I have not yet had the time to
>> look at it.)
>
> Perhaps you might try this patch and get a bit more information.

Running with it right now. Unless I missed one, the messages do happen 
exactly every five seconds. Here are the first few lines of the dmesg 
(grepping for 'intel ips'), and it does seem a bit strange:

$ dmesg | fgrep intel\ ips
intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
(found 25, expected 35)
intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: 25615533
intel ips 0000:00:1f.6: CPU power limit 8183 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6276 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 7952 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 7155 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5928 exceeded: 0
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: 70848
intel ips 0000:00:1f.6: CPU power limit 6430 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6474 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5508 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6569 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5250 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5023 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6209 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 7276 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 9027 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 7008 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5478 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6658 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5192 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6347 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5506 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4447 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4462 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4382 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4862 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5218 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4865 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4131 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5331 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6012 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5323 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4727 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4949 exceeded: 0
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: 69539
intel ips 0000:00:1f.6: CPU power limit 5045 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5070 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5113 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4262 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5158 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4865 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4302 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4430 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4841 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4532 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4814 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4803 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5139 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4050 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 6176 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4746 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 3739 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4863 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4917 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4099 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 4956 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 5018 exceeded: 0
intel ips 0000:00:1f.6: CPU power limit 3863 exceeded: 0

I think you put the parameters in the wrong order on the dev_info() call 
for the CPU power limit; it is the limit that is 0.

Two bogus things I can see:

- The first "MCP power limit exceeded" seems very bogus.
- What do you mean, core_power_limit is zero?

I will go back to 2.6.35; not feeling like debugging my (unrelated) 
suspend/resume problem right now. If you have another debugging patch, I 
will probably test it only tomorrow night.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
