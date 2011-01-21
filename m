Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1AUTSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:18:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1AUTSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:18:12 -0500
Date: Fri, 21 Jan 2011 20:17:57 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: werner <w.landgraf@ru.ru>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, idryomov@gmail.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: 2.6.38-rc1 problems with khugepaged
Message-ID: <20110121191757.GO9506@random.random>
References: <web-444048714@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-444048714@zbackend1.aha.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 06:43:44AM -0400, werner wrote:
> 2.6.38-rc1-git1 runs normally with khugepaged switched 
> OFF.  Thus, khugepaged  is the problem; as said if 
> switched it on, during boot the computer becomes very slow 
> and sticks almost.    wl

Sorry, looks like x86 32bit THP wasn't tested in all possible .config
(32bit support is upstream-only feature and because of lower userbase
it also got a lot less testing than 64bit support).

Does it make any difference if you both disable CONFIG_PARAVIRT and
enable HIGHMEM64?

For now keep THP off on 32bit, it should be trivial to reproduce so
fix will come soon.

Minchan info shows it's an 32bit arch bug so don't be too worried
about it because it can't affect 64bit builds and it's not common code
bug and we'll fix it ASAP.

Thanks,
Andrea
