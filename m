Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1EQO7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:59:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40073 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab1EQO7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:59:02 -0400
Message-ID: <4DD28D08.1030401@oracle.com>
Date: Tue, 17 May 2011 07:58:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ping: fix build failure
References: <20110516151019.be338f1c.sfr@canb.auug.org.au> <20110516123534.5d3a51b9.randy.dunlap@oracle.com> <20110516.153844.1072050131335197211.davem@davemloft.net> <20110517101656.GA28685@albatros>
In-Reply-To: <20110517101656.GA28685@albatros>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DD28D18.0147:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/11 03:16, Vasiliy Kulikov wrote:
> On Mon, May 16, 2011 at 15:38 -0400, David Miller wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> Date: Mon, 16 May 2011 12:35:34 -0700
>>
>>> On Mon, 16 May 2011 15:10:19 +1000 Stephen Rothwell wrote:
>>> when CONFIG_PROC_SYSCTL is not enabled:
>>>
>>> ping.c:(.text+0x52af3): undefined reference to `inet_get_ping_group_range_net'
>>
>> Vasiliy, please fix this.
> 
> I wonder whether there is any way to test such unusual configurations?
> Only randconfig or are there any (partly-)automated tools for it?

Hi,

I do automated (cron) randconfigs nightly and occasionally I run a script
that builds a kernel with each one of these options disabled (although
lately CONFIG_PM is not being disabled, but I'll fix that one day):

BLOCK HOTPLUG INET INPUT MAGIC_SYSRQ NET PCI PM PROC_FS SMP SYSFS

Hm, I should add SYSCTL (and/or PROC_SYSCTL) to that list.  It often has issues.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
