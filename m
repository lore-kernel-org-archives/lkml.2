Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2DUAek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:34:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41457 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2DUAei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:34:38 -0400
Message-ID: <4F92009C.9030301@acm.org>
Date: Fri, 20 Apr 2012 19:34:36 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: linux-kernel@vger.kernel.org, rob.herring@calxeda.com
Subject: Re: [BISECTED] ipmi_si not loading since 2.6.39
References: <20120420223833.GA7855@nik-comp.lan>
In-Reply-To: <20120420223833.GA7855@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
>   ipmi_si: Interface detection failed
>
> Then ipmitool is unable to control IPMI device.
>
> Works for 2.6.38, doesn't work for 2.6.39, 3.0.28, 3.4-rc1.
>
> I got this bisected to following commit:
>
> commit a1e9c9dd3383e6a1a762464ad604b1081774dbda
> Author: Rob Herring<rob.herring@calxeda.com>
> Date:   Wed Feb 23 15:37:59 2011 -0600
>
>      ipmi: convert OF driver to platform driver
>
>      of_bus is deprecated in favor of the plain platform bus. This patch
>      merges the ipmi OF driver with the existing platform driver.
>
>      CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
>
>      Compile tested with and without CONFIG_OF. Tested OF probe and
>      default probe cases.
>
>      Signed-off-by: Rob Herring<rob.herring@calxeda.com>
>      Signed-off-by: Grant Likely<grant.likely@secretlab.ca>
>
> I wonder whether this is a bug, or I'm doing something wrong?

If it used to work and now it doesn't, that's probably a bug, though you 
might be able to work around it with some direct settings.

What hardware is involved?  'cat /proc/ipmi/0/params' on a working 
kernel would be handy.  You can use that information to hot-add the BMC, 
that should be documented in Documentation/IPMI.txt

-corey
