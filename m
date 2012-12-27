Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2L0Win (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:38:43 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:60693 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0Wik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:38:40 -0500
Date: Thu, 27 Dec 2012 14:38:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Liu Hui-R64343 <r64343@freescale.com>
cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: echo 1 > /proc/sys/vm/compact_memory -> sh: write error: Bad
 address
In-Reply-To: <AD13664F485EE54694E29A7F9D5BE1AF4D35F3@039-SN2MPN1-021.039d.mgd.msft.net>
Message-ID: <alpine.DEB.2.00.1212271435250.18214@chino.kir.corp.google.com>
References: <AD13664F485EE54694E29A7F9D5BE1AF4D35F3@039-SN2MPN1-021.039d.mgd.msft.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2012, Liu Hui-R64343 wrote:

> diff --git a/mm/compaction.c b/mm/compaction.c
> index c4bc5ac..d3cb27f 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -732,8 +732,10 @@ int sysctl_compact_memory;
>  int sysctl_compaction_handler(struct ctl_table *table, int write,
>                         void __user *buffer, size_t *length, loff_t *ppos)
>  {
> -       if (write)
> -               return compact_nodes();
> +       if (write) {
> +               compact_nodes();
> +               return *length;
> +       }
> 
>         return 0;
>  }

No need to return the length at all, simply change compact_nodes() to 
return void, remove the return value, and do

	if (write)
		compact_nodes();
	return 0;

and it should be fixed.  Could you write a changelog that shows the before 
and after behavior (not necessarily the implementation), sign-off the 
patch as described in Documentation/SubmittingPatches, running 
scripts/get_maintainer.pl on your new patch file, and sending it to 
all addresses that are listed?
