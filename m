Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0CSOPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:15:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:55159 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab0CSOPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:15:40 -0400
Message-ID: <4BA386FC.2000901@nokia.com>
Date: Fri, 19 Mar 2010 16:15:24 +0200
From: Aaro Koskinen <aaro.koskinen@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: ext Arjan van de Ven <arjan@linux.intel.com>,
       ext Tony Lindgren <tony@atomide.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/bootgraph.pl: ignore times until the clock is
 running
References: <1268934595-22544-1-git-send-email-aaro.koskinen@nokia.com> <4BA26FE8.2070705@linux.intel.com>
In-Reply-To: <4BA26FE8.2070705@linux.intel.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2010 14:15:27.0806 (UTC) FILETIME=[9FFE65E0:01CAC76E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arjan van de Ven wrote:
> On 3/18/2010 10:49, Aaro Koskinen wrote:
>> The clock used for printk.time=1 does not necessarily start running
>> from zero. On such platforms the bootgraph does not work properly as
>> the calculated boottime will be too long.
> 
> can we fix the platform to be smarter instead ? I'd think that's needed anyway for various
> timers etc to actually work well

Hmm, on OMAP I have gotten so used to this "feature" that I never
thought it was a bug. However, I don't think it will affect anything
else than printk time stamps.

Anyway, I sent a fix proposal to linux-omap list:
http://marc.info/?l=linux-omap&m=126900738712041&w=2

>> To correct this, the patch modifies the script to accept only non-zero
>> start times. This ensures the report contains entries only from the
>> period when the clock was running.
>>
>> Signed-off-by: Aaro Koskinen<aaro.koskinen@nokia.com>
> 
> nothing wrong with the patch itself... just sad that it's needed to work around such bugs ;(
> 
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

I guess we can forget this patch if we agree the platform behaviour is
not correct.

A.
