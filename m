Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab0KRSrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:47:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33091
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755887Ab0KRSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:47:35 -0500
Date: Thu, 18 Nov 2010 10:48:00 -0800 (PST)
Message-Id: <20101118.104800.70193768.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: namhyung@gmail.com, klassert@mathematik.tu-chemnitz.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3c59x: fix build failure on !CONFIG_PCI
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CE3FBAC.3030503@oracle.com>
References: <20101116091408.abd36ec8.randy.dunlap@oracle.com>
	<1289960532.1663.24.camel@leonhard>
	<4CE3FBAC.3030503@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 17 Nov 2010 07:58:36 -0800

> On 11/16/10 18:22, Namhyung Kim wrote:
>> 2010-11-16 (ȭ), 09:14 -0800, Randy Dunlap:
>>> Hi,
>>>
>> 
>> Hi, Randy
>> 
>> 
>>> Interesting patch.  I have reported this build error and looked
>>> into fixing it, but did not come up with this solution.
>>>
>>> Looking at it more:  if CONFIG_PCI is not enabled, DEVICE_PCI() is NULL.
>>> That makes VORTEX_PCI() (with or without your patch) have a value of NULL.
>>>
>>> Is the line with the reported syntax error (3211) executed in
>>> function acpi_set_WOL() ?  If so, let's assume that vp->enable_wol is true.
>>> Then what happens on line 3211 (or 3213 after your patch)?
>>>
>>> 		if (VORTEX_PCI(vp)->current_state < PCI_D3hot)
>>> 			return;
>>>
>>> or if I am really confuzed this morning, please tell me how it works.
>>>
>> 
>> At first glance, I've noticed that the code above could make a NULL
>> dereference so I added NULL check prior to the line.
>> 
>> But after reading more code I realized that other pci-functions called
>> in acpi_set_WOL() would not work with NULL pci_dev pointer also. And I
>> found all callers of the acpi_set_WOL() already checked NULL pointer
>> before the call. Finally I could remove the NULL check and leave the
>> code as is. That's how it works. :)
> 
> I see.  and concur.  Thanks for the explanation.

Looks good to me too, applied, thanks!
