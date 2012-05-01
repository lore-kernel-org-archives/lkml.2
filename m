Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2EAR5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:57:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47266 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab2EAR5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:57:11 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAHGf_=qqiast+6XzGnq+LRdFXoWG9h2MkofmjS1h5OeNPRyWfw@mail.gmail.com>
References: <1335778207-6511-1-git-send-email-jack@suse.cz> <CAHGf_=qqiast+6XzGnq+LRdFXoWG9h2MkofmjS1h5OeNPRyWfw@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 2 May 2012 05:56:50 +1200
Message-ID: <CAKgNAkjAOGM+mZLkXGiDFYsnMCpJsxx=Nd5pZfx-_f4B1jvh+A@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-man@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 4:15 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
>> +suffices. However, if the user buffer is not page aligned and direct read
>
> One more thing. direct write also makes data corruption. Think
> following scenario,

In the light of all of the comments, can someone revise the man-pages
patch that Jan sent?

Thanks,

Michael


> 1) P1-T1 uses DIO write (and starting dma)
> 2) P1-T2 call fork() and makes P2
> 3) P1-T3 write to the dio target page. and then, cow break occur and
> original dio target
>    pages is now owned by P2.
> 4) P2 write the dio target page. It now does NOT make cow break. and
> now we break
>    dio target page data.
> 5) DMA transfer write invalid data to disk.
>
> The detail is described in your refer URLs.
>
>
>> +runs in parallel with a
>> +.BR fork (2)
>> +of the reader process, it may happen that the read data is split between
>> +pages owned by the original process and its child. Thus effectively read
>> +data is corrupted.
>>  .LP
>>  The
>>  .B O_DIRECT



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
