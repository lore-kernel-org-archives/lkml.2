Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1GSGID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1GSGIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:08:01 -0400
Message-ID: <4E251F07.1090204@redhat.com>
Date: Tue, 19 Jul 2011 14:07:03 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>	<CAOJsxLHuqvVEKg84jmRW_yfLic9ytB8GzeAE4YWauxSWryHGzA@mail.gmail.com>	<20110718170950.GD8006@one.firstfloor.org> <20110718101435.14c38ae7.rdunlap@xenotime.net>
In-Reply-To: <20110718101435.14c38ae7.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月19日 01:14, Randy Dunlap 写道:
> On Mon, 18 Jul 2011 19:09:50 +0200 Andi Kleen wrote:
>
>> On Mon, Jul 18, 2011 at 03:14:18PM +0300, Pekka Enberg wrote:
>>> On Mon, Jul 18, 2011 at 2:18 PM, Amerigo Wang<amwang@redhat.com>  wrote:
>>>> On ppc, we got this build error with randconfig:
>>>>
>>>> drivers/built-in.o:(.toc1+0xf90): undefined reference to `vmstat_text': 1 errors in 1 logs
>>>>
>>>> This is due to that it enabled CONFIG_NUMA but not CONFIG_SYSFS.
>>>>
>>>> And the user-space tool numactl depends on sysfs files too.
>>>> So, I think it is very reasonable to make CONFIG_NUMA depend on CONFIG_SYSFS.
>>>
>>> Is it? CONFIG_NUMA is useful even without userspace numactl tool, no?
>>
>> Yes it is. No direct dependency.
>>
>> I would rather fix it in ppc.
>
> This isn't a ppc-only error.  It happens when CONFIG_PROC_FS is not enabled
> (or is it CONFIG_SYSFS?).
>
> I reported it for linux-next of 20110526:
>
> when CONFIG_PROC_FS is not enabled:
>
> drivers/built-in.o: In function `node_read_vmstat':
> node.c:(.text+0x56ffa): undefined reference to `vmstat_text'
>

Right, I believe x86 has the same problem.
