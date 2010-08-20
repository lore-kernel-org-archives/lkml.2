Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab0HTMsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:48:33 -0400
Received: from SMTP02.SRV.CS.CMU.EDU ([128.2.217.197]:34771 "EHLO
	smtp02.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0HTMsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:48:30 -0400
Message-ID: <4C6E799A.7060902@cs.cmu.edu>
Date: Fri, 20 Aug 2010 08:48:26 -0400
From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc1 oopses at boot time in kobject allocation
References: <4C6D9289.4000702@cs.cmu.edu> <20100819203435.GA28508@suse.de>
In-Reply-To: <20100819203435.GA28508@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 04:34 PM, Greg KH wrote:
> On Thu, Aug 19, 2010 at 04:22:33PM -0400, Benjamin Gilbert wrote:
>> 2.6.36-rc1 and 2.6.36-rc1-127-g763008c fail to boot for me:
> 
> Can you run 'git bisect' to try to track this down?

commit f8a4bd3456b988fc73b2c291b9e01b434c8fa940
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Fri Jun 4 00:54:43 2010 -0700

    firmware loader: embed device into firmware_priv structure
    
    Both these structures have the same lifetime rules so instead of allocating
    and managing them separately embed struct device into struct firmware_priv.
    Also make sure to delete sysfs attributes ourselves instead of expecting
    sysfs to clean up our mess.
    
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


Of note, in the original dmesg log, ipw2200 fails to find its firmware
immediately before the backtraces start.  If I build ipw2200 as a module
instead, it finds its firmware and the system boots successfully.

--Benjamin Gilbert
