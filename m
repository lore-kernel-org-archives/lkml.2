Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab1KIWo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:44:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1KIWo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:44:58 -0500
Date: Wed, 9 Nov 2011 14:44:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, yinghan@google.com
Subject: Re: [PATCH] memcg: doc the pagefault count
Message-Id: <20111109144456.df8e4ccc.akpm@linux-foundation.org>
In-Reply-To: <1320398121-17336-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1320398121-17336-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Nov 2011 17:15:21 +0800
Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:

> Pagefault count has added to memcg stats since commit 456f998e,
> but forgot to doc it.
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  Documentation/cgroups/memory.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index cc0ebc5..081f4f44 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -389,6 +389,13 @@ mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
>  pgpgin		- # of pages paged in (equivalent to # of charging events).
>  pgpgout		- # of pages paged out (equivalent to # of uncharging events).
>  swap		- # of bytes of swap usage
> +
> +pgfault		- # of page-faults
> +pgmajfault	- # of major page-faults
> +		These two are different from "pgpgin"/"pgpgout" stat which
> +		count number of pages charged/discharged to the cgroup and
> +		have no meaning of reading/writing page to disk.
> +
>  inactive_anon	- # of bytes of anonymous memory and swap cache memory on

OK, but the documentation was already rather poor.

For a start, what do pgpgin and pgpgout actually count?  How about

pgpgin: the number of pages read from disk as a result of pagefault
activity within this memcg (swapin and mapped-file pagein).  Does not
include other causes of disk I/O such as read().

pgpgout: the number of pages written to disk as a result of swap and
mapped-file activity within this memcg.  Does not include other causes
of disk I/O such as write().

(I'm really not sure if this is correct!)

What are the units: is it "pages" or "multiples of 4k"?  If the latter
then userspace must go off and work out what pagesize the kernel is,
which is a bit ugly and is just asking for people to develop
monitoring tools which report wrong results on other-than-4k-pagesize
setups.


Once we have that settled then we can move on to documenting pgfault
and pgmajfault.  What are the units?  Exactly which kernel actions lead
to these counters being altered?

