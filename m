Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1BIX4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:56:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55450 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1BIX4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:56:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Feb 2011 08:50:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] memcg: operate on page quantities internally
Message-Id: <20110210085034.a6c5d703.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
References: <1297249313-23746-1-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Feb 2011 12:01:49 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi,
> 
> this patch set converts the memcg charge and uncharge paths to operate
> on multiples of pages instead of bytes.  It already was a good idea
> before, but with the merge of THP we made a real mess by specifying
> huge pages alternatingly in bytes or in number of regular pages.
> 
> If I did not miss anything, this should leave only res_counter and
> user-visible stuff in bytes.  The ABI probably won't change, so next
> up is converting res_counter to operate on page quantities.
> 

Hmm, I think this should be done but think this should be postphoned, too.
Because, IIUC, some guys will try to discuss charging against kernel objects
in the next mm-summit. IMHO, it will be done against PAGE not against
Object even if we do kernel object accouting. So this patch is okay for me.
But I think it's better to go ahead after we confirm the way we go.
How do you think ?

Anyway, I welcome this patch.

Thanks,
-Kame



> 	Hannes
> 
>  include/linux/sched.h |    4 +-
>  mm/memcontrol.c       |  157 ++++++++++++++++++++++++-------------------------
>  2 files changed, 78 insertions(+), 83 deletions(-)
> 

