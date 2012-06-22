Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762710Ab2FVVdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:33:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48903 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2FVVdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:33:33 -0400
Message-ID: <4FE4E4A8.1010105@suse.cz>
Date: Fri, 22 Jun 2012 23:33:28 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120610 Thunderbird/15.0a2
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, lwn@lwn.net,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.32.55
References: <20120125223434.GA31647@kroah.com> <4FE4C1A3.4080804@suse.cz> <20120622193824.GA3371@kroah.com> <4FE4DF41.30400@suse.cz> <20120622211824.GB18996@1wt.eu>
In-Reply-To: <20120622211824.GB18996@1wt.eu>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 11:18 PM, Willy Tarreau wrote:
>> Given nobody noticed till now, I would incline to drop that patch from
>> 2.6.32 series. Opinions?
> 
> Which one would you drop then ? You got me lost now. I mean, since you've
> been the only one to notice an issue, I have no problem with following you
> on the best way to fix it but I need to understand what you want then :-)

Ok, now I spent some time to look into that.

I thought suse does not need the original patch (PNP: work around Dell
1536/1546 BIOS MMCONFIG bug that breaks USB) as we do not support
CONFIG_AMD_NB. But in 2.6.32.55, it is named CONFIG_K8_NB. So actually
we need it.

There are two problems with the backport:
* missing amd_get_mmconfig_range (added by 24d25dbfa6)
* used wrong names: CONFIG_AMD_NB and asm/amd_nb.h

The latter can be fixed in two ways:
* easier: change CONFIG_AMD_NB to CONFIG_K8_NB and asm/amd_nb.h to
asm/k8.h (obviously, there will be no "upstream commit" for that)
* maybe harder: backport 23ac4ae827 including dependencies (I haven't
looked if there are any)

thanks,
-- 
js
suse labs
