Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0H0XMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 19:12:22 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:49060 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0H0XMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 19:12:21 -0400
Message-ID: <4C784650.2030200@cesarb.net>
Date: Fri, 27 Aug 2010 20:12:16 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>	 <4C770299.6000708@cesarb.net> <1282869660.1836.5.camel@Joe-Laptop>	 <4C77171E.6060008@cesarb.net> <1282894751.1836.41.camel@Joe-Laptop>
In-Reply-To: <1282894751.1836.41.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-08-2010 04:39, Joe Perches escreveu:
> On Thu, 2010-08-26 at 22:38 -0300, Cesar Eduardo Barros wrote:
>> intel ips 0000:00:1f.6: CPU power limit 3863 exceeded: 0
>>
>> I think you put the parameters in the wrong order on the dev_info() call
>> for the CPU power limit; it is the limit that is 0.
>
> Yes. Fixed.
>
>> Two bogus things I can see:
>>
>> - The first "MCP power limit exceeded" seems very bogus.
>> - What do you mean, core_power_limit is zero?
>
> I added a logging message whenever the turbo limits change
> and logging messages for power/temp on MCH for completeness.
>
> Maybe this will show something useful like when/how
> CPU power limit gets set to 0.

Running with it right now, did not help much:

$ dmesg | fgrep 'intel ips'
intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
(found 25, expected 35)
intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:8058 + 
mch:23392829
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5675
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6369
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:5095 + mch:65379
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 7387
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 8326
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5943
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6428
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5775
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 7061
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5153
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5098
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5208
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 7500
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 9144
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6722
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 7156
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:5693 + mch:64598
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5856
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4209
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4726
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5259
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5212
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4862
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5281
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4235
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4897
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5257
intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:5111 + mch:64134
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4843
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4909
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5904
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6059
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5579
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5970
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5213
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6388
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4444
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6545
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4439
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4682
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4337
intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 4499

Just for fun, here is what debugfs has to say:

$ ls /sys/kernel/debug/ips/
cpu_clamp  cpu_power  cpu_temp  mch_power  mch_temp
$ cat /sys/kernel/debug/ips/*
23.0W 21.0A
4415mW
46.99
59670mW
0.00

All numbers except the last vary a lot. A few more examples:

21.0W 21.0A
4379mW
51.09
6493mW
0.00

23.0W 21.0A
4681mW
45.13
34062mW
0.00

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
