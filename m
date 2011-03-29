Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1C2PBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:01:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53989 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1C2PBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:01:18 -0400
Message-ID: <4D91F432.2070406@oracle.com>
Date: Tue, 29 Mar 2011 08:01:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH] ubifs: fix kconfig dependency warning
References: <20110328134016.deb5d0c8.randy.dunlap@oracle.com> <1301382178.2816.69.camel@localhost>
In-Reply-To: <1301382178.2816.69.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D91F435.008A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/11 00:02, Artem Bityutskiy wrote:
> On Mon, 2011-03-28 at 13:40 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix another kconfig dependency warning, this time in ubifs.
>>
>> warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
>>
>> Without this patch, we can have:
>> # CONFIG_KALLSYMS is not set
>> CONFIG_KALLSYMS_ALL=y
>> which is useless (does nothing unless KALLSYMS is enabled).
>>
>> However, ubifs builds successfully with or without this patch,
>> and it builds with this line completely deleted,
>> so what was this 'select' for?  Just developer convenience?
> 
> Well, here is the idea. You can compile UBIFS with debugging and without
> debugging. Without debugging the resulting ubifs.ko is much smaller, so
> some embedded people prefer it this way.
> 
> If you select debugging support, then we'll compile it a lot of
> assertions, self-checks, test-modes, extra error messages with detailed
> dumps. And we want to see stackdumps when errors or problems happen,
> this is why we select KALLSYMS_ALL.
> 
> So I guess instead we should do:
> 
> select KALLSYMS
> select KALLSYMS_ALL

Yes, that should do it.  Thanks for the explanation.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
