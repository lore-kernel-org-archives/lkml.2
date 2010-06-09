Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0FIQjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:39:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65521 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0FIQjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:39:44 -0400
Subject: Re: [PATCHv5 04/16] VFS: add memory barrier to sb_mark_clean and
 sb_mark_dirty
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1275835829-1478-5-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
	 <1275835829-1478-5-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Wed, 09 Jun 2010 19:36:50 +0300
Message-ID: <1276101410.5677.158.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jun 2010 16:39:09.0003 (UTC) FILETIME=[488029B0:01CB07F2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 17:50 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> The proper way for file-systems to synchronize the superblock
> should be as follows:
> 
> 1. when modifying the SB, first modify it, then mark it as dirty;
> 2. when synchronizing the SB, first mark as clean, then start
>    synchronizing.
> 
> And to make ensure the order, we need memory barriers in 'sb_mark_clean()'
> and 'sb_mark_dirty()'.

I believe this stuff is a separate story, and should be handled
separately. I'll keep this separately from the 'sync_supers()' wakes up
optimization.

I actually now cannot prove myself whether these smp_mb()'s I added in
this patch make sense or not, and whether the races in FSes I was trying
to address can be addressed without spinlocks. Really dunno - but I will
keep trying to get better understanding. Reading
Documentation/memory-barriers.txt and some McKenny's docs only did not
help so far :-)

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

