Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1J1Inc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:43:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58530 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1J1Inb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:43:31 -0400
MIME-Version: 1.0
X-Originating-IP: [89.138.253.16]
In-Reply-To: <alpine.DEB.2.00.1110272307110.14619@router.home>
References: <1319384922-29632-1-git-send-email-gilad@benyossef.com>
	<1319384922-29632-5-git-send-email-gilad@benyossef.com>
	<alpine.DEB.2.00.1110272307110.14619@router.home>
Date: Fri, 28 Oct 2011 10:43:31 +0200
Message-ID: <CAOtvUMdjtork2uPTWWCT-bRLP2AAR+DA2_nxG-8MQe83MT=Vew@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:10 AM, Christoph Lameter <cl@gentwo.org> wrote:
> On Sun, 23 Oct 2011, Gilad Ben-Yossef wrote:
>
>> +/* Which CPUs have per cpu pages  */
>> +cpumask_var_t cpus_with_pcp;
>> +static DEFINE_PER_CPU(unsigned long, total_cpu_pcp_count);
>
> This increases the cache footprint of a hot vm path. Is it possible to do
> the same than what you did for slub? Run a loop over all zones when
> draining to check for remaining pcp pages and build the set of cpus
> needing IPIs temporarily while draining?
>

Sounds like a good idea. I will give it a shot.

Thanks,
Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "
