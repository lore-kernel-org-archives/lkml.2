Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2DFHQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:16:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2DFHQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:16:42 -0400
Message-ID: <4F7E9854.1020904@gmail.com>
Date: Fri, 06 Apr 2012 15:16:36 +0800
From: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Alexey Ivanov <rbtz@yandex-team.ru>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mapped pagecache pages vs unmapped pages
References: <37371333672160@webcorp7.yandex-team.ru>
In-Reply-To: <37371333672160@webcorp7.yandex-team.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 08:29 AM, Alexey Ivanov wrote:

> In progress of migration from FreeBSD to Linux and we found some strange behavior: periodically running tasks (like rsync/p2p deployment) evict mapped pages from memory.
> 
> From my little research I've found following lkml thread:
> https://lkml.org/lkml/2008/6/11/278
> And more precisely this commit: https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4f98a2fee8acdb4ac84545df98cccecfd130f8db
> which along with splitting LRU into "anon" and "file" removed support of reclaim_mapped.
> 
> Is there a knob to prioritize mapped memory over unmapped (without modifying all apps to use O_DIRECT/fadvise/madvise or mlocking our data in memory) or at least some way to change proportion of Active(file)/Inactive(file)?
> 


Hi Alexey,

Cc to linux-mm mailing list.

I have met the similar problem and I have sent a mail to discuss it.
Maybe it can help you
(http://marc.info/?l=linux-mm&m=132947026019538&w=2).

Now Konstantin has sent a patch set to try to expand vm_flags from 32
bit to 64 bit.  Then we can add the new flag into vm_flags and
prioritize mmaped pages in madvise(2).

Regards,
Zheng
