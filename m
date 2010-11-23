Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0KWXsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:48:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40167 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0KWXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i9lfPTT7WJEG9YXFOfDpNm7YTmVIMraLab3ZoB8dzWRB2SxJgS7QyjlXCecr1FONJj
         PyZ4hE3/fDiBVqYb+nTMbSNo+afFkViwGn0ZlbCv2PnlR5uiC/odr+Lydovj3eevixXJ
         Li1z8v75Xgh+EoV9RloQpnAMFmZpZn5VL9Zdw=
MIME-Version: 1.0
In-Reply-To: <87mxp09mm2.fsf@gmail.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<874obawvlt.fsf@gmail.com>
	<20101122103756.E236.A69D9226@jp.fujitsu.com>
	<87mxp09mm2.fsf@gmail.com>
Date: Wed, 24 Nov 2010 08:48:49 +0900
Message-ID: <AANLkTikhmSZ=oa7ebNqopdV++HgA6wCPnHbHQvwN8eyp@mail.gmail.com>
Subject: Re: [RFC 1/2] deactive invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Ben Gamari <bgamari@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 10:48 PM, Ben Gamari <bgamari@gmail.com> wrote:
> On Tue, 23 Nov 2010 16:16:55 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > On Sun, 21 Nov 2010 23:30:23 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
>> > >
>> > > Ben, Remain thing is to modify rsync and use
>> > > fadvise(POSIX_FADV_DONTNEED). Could you test it?
>> >
>> > Thanks a ton for the patch. Looks good. Testing as we speak.
>>
> For the record, this was a little premature. As I spoke the kernel was
> building but I still haven't had a chance to take any data. Any
> suggestions for how to determine the effect (or hopefully lack thereof)
> of rsync on the system's working set?
>
>> If possible, can you please post your rsync patch and your testcase
>> (or your rsync option + system memory size info + data size info)?
>>
> Patch coming right up.
>
> The original test case is a backup script for my home directory. rsync
> is invoked with,
>
> rsync --archive --update --progress --delete --delete-excluded
> --exclude-from=~/.backup/exclude --log-file=~/.backup/rsync.log -e ssh
> /home/ben ben@myserver:/mnt/backup/current
>
> My home directory is 120 GB with typical delta sizes of tens of
> megabytes between backups (although sometimes deltas can be gigabytes,
> after which the server has severe interactivity issues). The server is
> unfortunately quite memory constrained with only 1.5GB of memory (old
> inherited hardware). Given the size of my typical deltas, I'm worried
> that even simply walking the directory hierarchy might be enough to push
> out my working set.
>
> Looking at the rsync access pattern with strace it seems that it does
> a very good job of avoid duplicate reads which is good news for these
> patches.

Thanks for the notice. Ben.
FYI, we have a plan to change the policy as you look this thread.
Maybe It would be good than my current policy in the page.

Please recognize it. :)

>
> Cheers,
>
> - Ben
>
>
>



-- 
Kind regards,
Minchan Kim
