Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1DBMWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 08:22:08 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36027 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1DBMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 08:22:06 -0400
Message-ID: <4D9714E3.8010302@linux.vnet.ibm.com>
Date: Sat, 02 Apr 2011 17:51:55 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [linux-pm] [PATCH 04/18] x86 idle: EXPORT_SYMBOL(default_idle,
 pm_idle) only when APM demands it
References: <alpine.LFD.2.02.1104010020280.2797@x980> <1301725380-10579-1-git-send-email-lenb@kernel.org> <dba24a423948935d0a0c1eb32414a476f3f90e02.1301724243.git.len.brown@intel.com> <20110402122857.5fb7d2b7@lxorguk.ukuu.org.uk>
In-Reply-To: <20110402122857.5fb7d2b7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/02/2011 04:58 PM, Alan Cox wrote:
> On Sat, 02 Apr 2011 02:22:46 -0400
> Len Brown<lenb@kernel.org>  wrote:
>
>> From: Len Brown<len.brown@intel.com>
>>
>> In the long run, we don't want default_idle() or (pm_idle)() to
>> be exported outside of process.c.  Start by not exporting them
>> to modules, unless the APM build demands it.
>
> Pointless added complexity. Why are you so determined to minimise this -
> it makes no odds to anyone.

Hi Alan,

I am not sure if I have understood you correctly but
I think one problem is that modules such as APM
save the value of pm_idle pointer, set it and restore it back.

At module init:

original_pm_idle = pm_idle;
pm_idle  = apm_cpu_idle;

At module exit:

pm_idle = original_pm_idle;

There is no guarantee that the pointer stored
is still valid. I think people have problem with such
usage; see http://lkml.org/lkml/2009/8/28/50

Thanks,
-Trinabh
