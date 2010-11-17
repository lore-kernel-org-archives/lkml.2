Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0KQCWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:22:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59247 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0KQCWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aTIWcicxtq0TuaYufe1E+sIcyH0FmkkNtKjnRG0LOS7AAJ05Fxpn5KNpuI3ooESCdw
         kDOOD7PQtdkHyLDTY1zdV/5rlDSax1D2IkuFJMmqwKzkngQn1XoACD9Rv00Q3+d3+41J
         oVNc/CIN95vILrcSZmPeQn+a5S+D3Y1ndiIMI=
Subject: Re: [PATCH] 3c59x: fix build failure on !CONFIG_PCI
From: Namhyung Kim <namhyung@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101116091408.abd36ec8.randy.dunlap@oracle.com>
References: <1289921271-15295-1-git-send-email-namhyung@gmail.com>
	 <20101116091408.abd36ec8.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 11:22:12 +0900
Message-ID: <1289960532.1663.24.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-16 (화), 09:14 -0800, Randy Dunlap:
> Hi,
> 

Hi, Randy


> Interesting patch.  I have reported this build error and looked
> into fixing it, but did not come up with this solution.
> 
> Looking at it more:  if CONFIG_PCI is not enabled, DEVICE_PCI() is NULL.
> That makes VORTEX_PCI() (with or without your patch) have a value of NULL.
> 
> Is the line with the reported syntax error (3211) executed in
> function acpi_set_WOL() ?  If so, let's assume that vp->enable_wol is true.
> Then what happens on line 3211 (or 3213 after your patch)?
> 
> 		if (VORTEX_PCI(vp)->current_state < PCI_D3hot)
> 			return;
> 
> or if I am really confuzed this morning, please tell me how it works.
> 

At first glance, I've noticed that the code above could make a NULL
dereference so I added NULL check prior to the line.

But after reading more code I realized that other pci-functions called
in acpi_set_WOL() would not work with NULL pci_dev pointer also. And I
found all callers of the acpi_set_WOL() already checked NULL pointer
before the call. Finally I could remove the NULL check and leave the
code as is. That's how it works. :)

Thanks.

-- 
Regards,
Namhyung Kim


