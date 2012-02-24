Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2BXNFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:05:43 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41979 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab2BXNFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:05:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120223122215.d280b090.akpm@linux-foundation.org>
References: <20120222150010.c784b29b.akpm@linux-foundation.org>
	<1329969811-3997-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120223122215.d280b090.akpm@linux-foundation.org>
Date: Fri, 24 Feb 2012 18:35:40 +0530
Message-ID: <CAAHN_R3zjh-xQ9yW57JhQ=AiJG+DV6D_ppveh3BvUYy8NWU3Lg@mail.gmail.com>
Subject: Re: [PATCH] Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jamie Lokier <jamie@shareable.org>,
        Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 1:52 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Looks OK to me, thanks.  I doubt if those interface changes will cause
> significant disruption.
>

I just found one breakage due to this patch: `cat /proc/self/maps`
does not always get the stack marked right. I think this is because it
gets the $esp a little to early, even before the vma is sent to its
randomized space. That is why /proc/self/smaps works just ok as it
always wins the race due to the sheer volume of data it prints.
Similarly numa_maps always fails since its write volume is lower than
maps. I'll try to fix this.

-- 
Siddhesh Poyarekar
http://siddhesh.in
