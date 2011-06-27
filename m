Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1F0FlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:41:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41397 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab1F0FjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:39:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E081764.7040709@jp.fujitsu.com>
Date: Mon, 27 Jun 2011 14:38:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: P@draigBrady.com
CC: andrea@betterlinux.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
        riel@redhat.com, peterz@infradead.org, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hughd@google.com,
        jamesjer@betterlinux.com, marcus@bluehost.com, matt@bluehost.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] fadvise: move active pages to inactive list with
 POSIX_FADV_DONTNEED
References: <1308779480-4950-1-git-send-email-andrea@betterlinux.com> <4E03200D.60704@draigBrady.com>
In-Reply-To: <4E03200D.60704@draigBrady.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, What if you do want to evict it from the cache for testing purposes?
> Perhaps this functionality should be associated with POSIX_FADV_NOREUSE?
> dd has been recently modified to support invalidating the cache for a file,
> and it uses POSIX_FADV_DONTNEED for that.
> http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=5f311553

This change don't break dd. dd don't have a special privilege of file cache
dropping if it's also used by other processes.

if you want to drop a cache forcely (maybe for testing), you need to use
/proc/sys/vm/drop_caches. It's ok to ignore other processes activity because
it's privilege operation.

Thanks.

