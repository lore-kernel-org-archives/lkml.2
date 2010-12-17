Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0LQSTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:19:06 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:39302 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab0LQSTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=Wnizae2/6UD4IoF9ylvwGiP+DtwOgZbvlSlDtN24ZJzgEsp+AuMQHeheQxZoK7AJTa
         un/gf7VBmFNsmZUYqCJHVKIo1SDldjYL5qGM6MRg7bcOQUZRQYNvZc72LTQPpLLqDpZa
         E97VRfHkhy7hOzjt7ECvKuqjF5tW2546+mZxM=
MIME-Version: 1.0
From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 17 Dec 2010 13:13:47 -0500
X-Google-Sender-Auth: Rf2X56p_IZYwpcrAgBlIzV5qdG4
Message-ID: <AANLkTi=H3-GrEZVWzmHyHvyx93HU6x=t_n6TBqCiEwxX@mail.gmail.com>
Subject: reproducer for DM on MD flush deadlock? (was: Re: [PULL REQUEST] md
 bug fixes)
To: Neil Brown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 2:22 AM, Neil Brown <neilb@suse.de> wrote:
>
>
> Hi Linus,
>  here are a few bug fixes for md.
>  Some of the patches are actually clean-up rather than bug-fix,
>  but I that make the bugfix simpler to review.
>
> Thanks,
> NeilBrown
>
>
> The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:
>
>  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)
>
> are available in the git repository at:
>
>  git://neil.brown.name/md/ for-linus
>
> NeilBrown (5):
>      md: remove handling of flush_pending in md_submit_flush_data
>      md: move code in to submit_flushes.
>      md: fix possible deadlock in handling flush requests.

Hi Neil,

Thanks for fixing this DM on MD flush issue.  But my attempts to
reproduce it have been unsuccessful.

I've tried ext4 w/ barriers to a DM device above a 2 member MD RAID1.
The DM device has a table with 2 linear targets to the same md0
device:

# dmsetup table
multiple_targets: 0 24576 linear 9:0 2048
multiple_targets: 24576 49152 linear 9:0 26624

No amount of IO with flushes has enabled me to hit a deadlock (in
md_flush_request,  md_write_start, etc).

Do you have a simple reproducer for this issue?

Mike
