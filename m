Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2AIKPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:15:46 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42051 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2AIKPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:15:45 -0500
Message-ID: <4F0ABE3F.2040307@openwrt.org>
Date: Mon, 09 Jan 2012 11:15:27 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: cesarb@cesarb.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r6040: fix typo in use of MCR0 register bits
References: <1325949197-10143-1-git-send-email-cesarb@cesarb.net> <20120107.120947.1387951434734479835.davem@davemloft.net>
In-Reply-To: <20120107.120947.1387951434734479835.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/12 21:09, David Miller wrote:
> From: Cesar Eduardo Barros<cesarb@cesarb.net>
> Date: Sat,  7 Jan 2012 13:13:17 -0200
>
>> Commit 4e16d6ebd65b4f2c4e3f780b4c5704beef64019c (r6040: define more MCR0
>> register bits) added #define values for MCR0 register bits and converted
>> uses of hardcoded magic values to uses of these defines.
>>
>> However, one of the conversions looks suspicious:
>>
>>   #define MCR0		0x00	/* Control register 0 */
>> +#define  MCR0_RCVEN	0x0002	/* Receive enable */
>> +#define  MCR0_XMTEN	0x1000	/* Transmission enable */
>>
>>   	/* Init RDC private data */
>> -	lp->mcr0 = 0x1002;
>> +	lp->mcr0 = MCR0_XMTEN | MCR0;
>>
>> I believe what was meant here was MCR0_XMTEN | MCR0_RCVEN, which makes
>> sense and matches the original values.
>>
>> Signed-off-by: Cesar Eduardo Barros<cesarb@cesarb.net>
> Good catch, applied, thanks a lot.
Indeed, thanks Cesar.
--
Florian
