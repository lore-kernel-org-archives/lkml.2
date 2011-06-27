Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1F0JTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:19:34 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:7130 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756718Ab1F0JR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:17:57 -0400
Message-ID: <4E084AA7.2030701@draigBrady.com>
Date: Mon, 27 Jun 2011 10:17:27 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: andrea@betterlinux.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
        riel@redhat.com, peterz@infradead.org, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hughd@google.com,
        jamesjer@betterlinux.com, marcus@bluehost.com, matt@bluehost.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] fadvise: move active pages to inactive list with
 POSIX_FADV_DONTNEED
References: <1308779480-4950-1-git-send-email-andrea@betterlinux.com> <4E03200D.60704@draigBrady.com> <4E081764.7040709@jp.fujitsu.com>
In-Reply-To: <4E081764.7040709@jp.fujitsu.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/11 06:38, KOSAKI Motohiro wrote:
>> Hmm, What if you do want to evict it from the cache for testing purposes?
>> Perhaps this functionality should be associated with POSIX_FADV_NOREUSE?
>> dd has been recently modified to support invalidating the cache for a file,
>> and it uses POSIX_FADV_DONTNEED for that.
>> http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commitdiff;h=5f311553
> 
> This change don't break dd. dd don't have a special privilege of file cache
> dropping if it's also used by other processes.
> 
> if you want to drop a cache forcely (maybe for testing), you need to use
> /proc/sys/vm/drop_caches. It's ok to ignore other processes activity because
> it's privilege operation.

Well the function and privileges are separate things.
I think we've agreed that the new functionality is
best associated with POSIX_FADV_NOREUSE,
and the existing functionality with POSIX_FADV_DONTNEED.

BTW, I don't think privileges are currently enforced
as I got root to cache a file here with:
  # (time md5sum; sleep 100) < big.file
And a normal user was able to uncache with:
  $ dd iflag=nocache if=big.file count=0
Anyway as said, this is a separate "issue".

cheers,
Pádraig.
