Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2FVVKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:10:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42465 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2FVVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:10:29 -0400
Message-ID: <4FE4DF41.30400@suse.cz>
Date: Fri, 22 Jun 2012 23:10:25 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120610 Thunderbird/15.0a2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org, lwn@lwn.net,
        Willy Tarreau <w@1wt.eu>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.32.55
References: <20120125223434.GA31647@kroah.com> <4FE4C1A3.4080804@suse.cz> <20120622193824.GA3371@kroah.com>
In-Reply-To: <20120622193824.GA3371@kroah.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 09:38 PM, Greg KH wrote:
> On Fri, Jun 22, 2012 at 09:04:03PM +0200, Jiri Slaby wrote:
>> On 01/25/2012 11:34 PM, Greg KH wrote:
>>> I'm announcing the release of the 2.6.32.55 kernel.
>> ...
>>> Bjorn Helgaas (1): PNP: work around Dell 1536/1546 BIOS MMCONFIG
>>> bug that breaks USB
>>
>> Hi, this one is dependant on 24d25dbfa63c3 (x86/PCI: amd: factor out
>> MMCONFIG discovery), otherwise amd_get_mmconfig_range is undefined...
> 
> Interesting that this was reported almost 6 months after it was released :)

Yes :). This is because it is inside #ifdef CONFIG_AMD_NB which perhaps
nobody has set in 2.6.32. (Other than that we have the kernel in suse
enterprise for some time already.)

@Willy: 24d25dbfa63c3 is not enough. The header referenced in
2.6.32.55's patch does not exist in that tree yet. It was renamed from
asm/k8.h to asm/amd_nb.h later (by 23ac4ae827e62).

Given nobody noticed till now, I would incline to drop that patch from
2.6.32 series. Opinions?

> Anyway, I'm no longer handling 2.6.32 kernel stuff anymore, so there's
> nothing I can do here, sorry.

Yeah, I see, I replied to the announcement and added Willy. Your email
was @ suse, so you should have not received a copy anyway :).

thanks,
-- 
js
suse labs
