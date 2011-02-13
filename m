Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1BMSiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 13:38:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48771
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733Ab1BMSiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 13:38:09 -0500
Date: Sun, 13 Feb 2011 10:38:45 -0800 (PST)
Message-Id: <20110213.103845.02286551.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: kurt.van.dijck@eia.be, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next/mmotm] net/can: fix softing build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D58004A.3060407@oracle.com>
References: <4D56AF22.4070803@oracle.com>
	<20110213133717.GA508@e-circ.dyndns.org>
	<4D58004A.3060407@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Sun, 13 Feb 2011 08:01:14 -0800

> On 02/13/11 05:37, Kurt Van Dijck wrote:
>> The 'select CAN_SOFTING' was introduced because it makes no sense to
>> have CAN_SOFTING_CS alone 'for a normal user', although there is no
>> real dependency.
>> Is a 'select' then still a good option, since it feels like repeating
>> all dependencies from CAN_SOFTING in CAN_SOFTING_CS?
>> What about this?
>> 
>> diff --git a/drivers/net/can/softing/Kconfig b/drivers/net/can/softing/Kconfig
>> index 92bd6bd..55dd3e4 100644
>> --- a/drivers/net/can/softing/Kconfig
>> +++ b/drivers/net/can/softing/Kconfig
>> @@ -18,7 +18,7 @@ config CAN_SOFTING
>>  config CAN_SOFTING_CS
>>  	tristate "Softing Gmbh CAN pcmcia cards"
>>  	depends on PCMCIA
>> -	select CAN_SOFTING
>> +	depends on CAN_SOFTING
>>  	---help---
>>  	  Support for PCMCIA cards from Softing Gmbh & some cards
>>  	  from Vector Gmbh.
>> ---
>> It will present the Softing stuff in Kconfig as if CAN_SOFTING_CS really
>> depends on CAN_SOFTING, which is acceptible from a users perspective.
> 
> That's fine.
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Kurt, please formally re-submit this with a proper commit message,
a signoff for you, and Randy's ACK.

Thanks.
