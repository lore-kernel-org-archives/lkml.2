Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab1A2Mr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 07:47:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41515 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1A2Mr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 07:47:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nR/U2p44ERWq1L3ULJSWcURoPVpfXCH5KjiHPoXws2fw0/rGfYjvrydmspn606NOCi
         6Ytv3bf3vXbHSlFvlr++winiMhAxQR1pMf3dI9MYAcgrqlHtDD+q4QWyYdM4ggvPBdT7
         4PtG9TaV0Xrk9bf+vmvkZjsjSfM8ntgCadJ4g=
MIME-Version: 1.0
In-Reply-To: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 29 Jan 2011 18:17:56 +0530
X-Google-Sender-Auth: 304ybpkDzBIT3Uc8LCdcaLHLMH0
Message-ID: <AANLkTiktzgxEVROyB=-0ZNq5xzao1Q-Cu3xpGqhx0gxm@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH 0/4] Fixes for memcg with THP
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 8:52 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> On recent -mm, when I run make -j 8 under 200M limit of memcg, as
> ==
> # mount -t cgroup none /cgroup/memory -o memory
> # mkdir /cgroup/memory/A
> # echo 200M > /cgroup/memory/A/memory.limit_in_bytes
> # echo $$ > /cgroup/memory/A/tasks
> # make -j 8 kernel
> ==
>
> I see hangs with khugepaged. That's because memcg's memory reclaim
> routine doesn't handle HUGE_PAGE request in proper way. And khugepaged
> doesn't know about memcg.
>
> This patch set is for fixing above hang. Patch 1-3 seems obvious and
> has the same concept as patches in RHEL.

Do you have any backtraces? Are they in the specific patches?

Balbir
