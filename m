Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2HHXFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:05:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2HHXFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:05:05 -0400
Date: Wed, 08 Aug 2012 16:05:04 -0700 (PDT)
Message-Id: <20120808.160504.2177426106219233783.davem@davemloft.net>
To: remi@remlab.net
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] cdc-phonet: Don't leak in usbpn_open
From: David Miller <davem@davemloft.net>
In-Reply-To: <201208081012.07772.remi@remlab.net>
References: <alpine.LNX.2.00.1208072354030.3227@swampdragon.chaosbits.net>
	<201208081012.07772.remi@remlab.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rémi Denis-Courmont" <remi@remlab.net>
Date: Wed, 8 Aug 2012 10:12:06 +0300

> Le mercredi 8 août 2012 00:56:26 Jesper Juhl, vous avez écrit :
>> We allocate memory for 'req' with usb_alloc_urb() and then test
>> 'if (!req || rx_submit(pnd, req, GFP_KERNEL | __GFP_COLD))'.
>> If we enter that branch due to '!req' then there is no problem. But if
>> we enter the branch due to 'req' being != 0 and the 'rx_submit()' call
>> being false, then we'll leak the memory we allocated.
>> Deal with the leak by always calling 'usb_free_urb(req)' when entering
>> the branch. If 'req' happens to be 0 then the call is harmless, if it
>> is not 0 then we free the memory we allocated but don't need.
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Acked-by: Rémi Denis-Courmont <remi@remlab.net>

Applied.
