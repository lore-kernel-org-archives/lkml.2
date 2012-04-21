Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2DUAli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:41:38 -0400
Received: from smtp129.dfw.emailsrvr.com ([67.192.241.129]:37125 "EHLO
	smtp129.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2DUAlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:41:37 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2012 20:41:37 EDT
Message-ID: <4F92004F.70905@calxeda.com>
Date: Fri, 20 Apr 2012 19:33:19 -0500
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: linux-kernel@vger.kernel.org, minyard@acm.org
Subject: Re: [BISECTED] ipmi_si not loading since 2.6.39
References: <20120420223833.GA7855@nik-comp.lan>
In-Reply-To: <20120420223833.GA7855@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 05:38 PM, Nikola Ciprich wrote:
> Hello,
> 
> I was trying to find out why IPMI stopped working on new kernels. Since 2.6.39
> module loading ends with following message:
> 
>  ipmi_si: Interface detection failed
> 
> Then ipmitool is unable to control IPMI device. 
> 
> Works for 2.6.38, doesn't work for 2.6.39, 3.0.28, 3.4-rc1.
> 
> I got this bisected to following commit:
> 
> commit a1e9c9dd3383e6a1a762464ad604b1081774dbda
> Author: Rob Herring <rob.herring@calxeda.com>
> Date:   Wed Feb 23 15:37:59 2011 -0600
> 
>     ipmi: convert OF driver to platform driver
>     
>     of_bus is deprecated in favor of the plain platform bus. This patch
>     merges the ipmi OF driver with the existing platform driver.
>     
>     CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
>     
>     Compile tested with and without CONFIG_OF. Tested OF probe and
>     default probe cases.
>     
>     Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> 
> I wonder whether this is a bug, or I'm doing something wrong?
> 

It has been working for me as a module in the DT case.

This driver has several init paths with acpi, pci, fixed standard
addresses, and device tree. Can you provide some details on your h/w and
kernel log of working the working case.

Rob


> Thanks in advance!
> 
> with best regards
> 
> nik
> 
> 
