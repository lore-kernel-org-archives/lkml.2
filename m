Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab0E1R2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:28:17 -0400
Received: from king.tilera.com ([72.1.168.226]:7030 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab0E1R2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:28:15 -0400
Message-ID: <4BFFFD2B.8050402@tilera.com>
Date: Fri, 28 May 2010 13:28:11 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <201005252345.15685.arnd@arndb.de> <4BFFF330.4080509@tilera.com> <201005281916.12999.arnd@arndb.de>
In-Reply-To: <201005281916.12999.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 17:28:13.0911 (UTC) FILETIME=[26D87670:01CAFE8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/2010 1:16 PM, Arnd Bergmann wrote:
> On Friday 28 May 2010, Chris Metcalf wrote:
>   
>> I looked at where inb() and friends are used, and although we can get
>> close to not requiring them for tile, it's not quite there, and will
>> need some further discussions on the various lists to clean up enough
>> for our purposes.  There are three problems that surface when I try to
>> remove the inb family:
>>
>> 1. The ide-io-std.c file sets up the default_tp_ops, which we override
>> in our IDE driver, but we still have to build this file, and it contains
>> calls to inb, etc.
>>     
> It's only needed in the IDE layer though and will go away once you
> move to an ATA driver, right?
>   

That sounds plausible, though I haven't looked at what's involved with
this yet.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


