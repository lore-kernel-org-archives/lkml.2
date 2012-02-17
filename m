Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab2BQNcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:32:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34219 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2BQNcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:32:14 -0500
Message-ID: <4F3E56DA.3050203@openvz.org>
Date: Fri, 17 Feb 2012 17:32:10 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
References: <4F3E42E0.4030108@openvz.org>	<20120217120815.25909.15632.stgit@zurg> <20120217234508.8293a84fb3ebb7fed6d60ec3@canb.auug.org.au>
In-Reply-To: <20120217234508.8293a84fb3ebb7fed6d60ec3@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Konstantin,
>
> On Fri, 17 Feb 2012 16:08:15 +0400 Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>>
>> Config NUMA must be defined for all architectures,
>> otherwise IS_ENABLED(CONFIG_NUMA) does not work.
>> Some arch-specific Kconfig already has this stub.
>> This patch adds it to all remaining.
>
> Why not add it somewhere generic (like mm/Kconfig, maybe) and then it can
> be removed from the architecture specific places over time (if necessary
> - I am pretty sure it is ok to have it there twice)?
>

Different architectures has different dependencies for NUMA.

Seems like Kconfig allow config option duplication, but it use default state from first.
If we add "config NUMA\n def_bool n" somewhere in generic Kconfig, default will be n if
Kconfig see this declaration first.
