Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2HMWDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:03:01 -0400
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:60149 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2HMWC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:02:58 -0400
Message-ID: <5029798A.5000605@genband.com>
Date: Mon, 13 Aug 2012 16:02:50 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: "J.Hwan Kim" <frog1120@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: allocation of contiguous memory in kernel mode
References: <5023DB76.1030908@gmail.com>
In-Reply-To: <5023DB76.1030908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2012 22:02:51.0197 (UTC) FILETIME=[61D8C6D0:01CD799F]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19112.001
X-TM-AS-Result: No--12.743500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 09:47 AM, J.Hwan Kim wrote:
> Hi, everyone
>
> I wish to alloc physically contiguous memory in kernel mode.
> I used the __get_free_pages(gfp_mask, order) function,
> but it fails occasionary.
> I guess it is caused by memory fragmentation.
> My code is kernel driver module which cannot use
> bootmem allocation and its platform is x86_64.
> My server desktop has 20GB memory.
> I wish to know the method to allocate physically
> contiguous memory not failing by fragmentation.

There is no easy answer.

The most portable option is to change the requirements so that you don't 
need physically contiguous memory.  This is what most network devices 
did to handle jumbo frames.

Can you build a new kernel with your code added instead of using a module?

What about booting with artificially limited physical memory (on the 
kernel commandline) and then have the module explictly map in memory 
from above the usual memory limit?

Chris
