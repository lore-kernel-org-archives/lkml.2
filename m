Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934896Ab0KQP7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:59:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59593 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934749Ab0KQP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:59:48 -0500
Message-ID: <4CE3FBAC.3030503@oracle.com>
Date: Wed, 17 Nov 2010 07:58:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3c59x: fix build failure on !CONFIG_PCI
References: <1289921271-15295-1-git-send-email-namhyung@gmail.com>	 <20101116091408.abd36ec8.randy.dunlap@oracle.com> <1289960532.1663.24.camel@leonhard>
In-Reply-To: <1289960532.1663.24.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/10 18:22, Namhyung Kim wrote:
> 2010-11-16 (화), 09:14 -0800, Randy Dunlap:
>> Hi,
>>
> 
> Hi, Randy
> 
> 
>> Interesting patch.  I have reported this build error and looked
>> into fixing it, but did not come up with this solution.
>>
>> Looking at it more:  if CONFIG_PCI is not enabled, DEVICE_PCI() is NULL.
>> That makes VORTEX_PCI() (with or without your patch) have a value of NULL.
>>
>> Is the line with the reported syntax error (3211) executed in
>> function acpi_set_WOL() ?  If so, let's assume that vp->enable_wol is true.
>> Then what happens on line 3211 (or 3213 after your patch)?
>>
>> 		if (VORTEX_PCI(vp)->current_state < PCI_D3hot)
>> 			return;
>>
>> or if I am really confuzed this morning, please tell me how it works.
>>
> 
> At first glance, I've noticed that the code above could make a NULL
> dereference so I added NULL check prior to the line.
> 
> But after reading more code I realized that other pci-functions called
> in acpi_set_WOL() would not work with NULL pci_dev pointer also. And I
> found all callers of the acpi_set_WOL() already checked NULL pointer
> before the call. Finally I could remove the NULL check and leave the
> code as is. That's how it works. :)

I see.  and concur.  Thanks for the explanation.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
