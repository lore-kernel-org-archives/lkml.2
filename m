Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1JDFog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 01:44:36 -0400
Received: from mx2.parallels.com ([64.131.90.16]:54070 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab1JDFof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 01:44:35 -0400
Message-ID: <4E8A9D04.7060002@parallels.com>
Date: Tue, 4 Oct 2011 09:43:32 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>, <avagin@parallels.com>
Subject: Re: [PATCH v4 4/8] per-cgroup tcp buffers control
References: <1317637123-18306-1-git-send-email-glommer@parallels.com> <1317637123-18306-5-git-send-email-glommer@parallels.com> <20111004101633.6b44201d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111004101633.6b44201d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 05:16 AM, KAMEZAWA Hiroyuki wrote:
> It seems memcg->tcp.tcp_memory_pressure has no locks and not atomic.
>
> no problematic race ?
>
> Thanks,
> -Kame
Well,

prior to this patch, it was a global variable. And nobody complained so 
far...

My impression is that the only thing that really needs to be atomic is
the memory accounting, which is already. If we miss a memory pressure 
condition entry, we'll get to it next time.

