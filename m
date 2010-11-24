Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0KXAUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:20:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39204 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab0KXAUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:20:18 -0500
Message-ID: <4CEC59CB.1010105@oracle.com>
Date: Tue, 23 Nov 2010 16:18:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 23 (sep_driver)
References: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
In-Reply-To: <20101123140609.2b6503ff.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 14:06:09 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101122:


sep_driver build on x86_64 gets lots of printk format warnings.
There are 2 categories of these warnings.
(a) using %x for a size_t, when it should be %zx
(b) using %x for some _IOW() constant: no warning on i386, but
	x86_64 says:

drivers/staging/sep/sep_driver.c:3415: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'

where lines 3415-3416 are:

	dev_dbg(&sep->pdev->dev,
		"SEP_IOCPREPAREDCB is %x\n", SEP_IOCPREPAREDCB);

Changing that to:

	dev_dbg(&sep->pdev->dev,
		"SEP_IOCPREPAREDCB is %lx\n", (unsigned long)SEP_IOCPREPAREDCB);

obviously fixes the printk format warning, but is there a better solution?


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
