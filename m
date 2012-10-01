Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2JAIDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:03:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37543 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2JAIDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:03:11 -0400
Message-ID: <50694E2E.7090909@gmail.com>
Date: Mon, 01 Oct 2012 10:02:54 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Sasikantha Babu <sasikanth.v19@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Trevor Woerner <twoerner@gmail.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: ABI change for setitimer(2) [in feature-removal-schedule.txt]
References: <CAHO5Pa2dnFH+SVkrJngR8Vn4VomsfJ00nOCzRB3+Ns4zs_pxnQ@mail.gmail.com> <CA+55aFyjvESz3FZwAdnOuZX7R5B0ES0Vj3SngikA1A9PqTcoyQ@mail.gmail.com>
In-Reply-To: <CA+55aFyjvESz3FZwAdnOuZX7R5B0ES0Vj3SngikA1A9PqTcoyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 7:51 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Sep 29, 2012 at 11:30 PM, Michael Kerrisk
> <mtk.manpages@gmail.com> wrote:
>>
>>> I think the whole "let's deprecate this six months into the future" is
>>> unnecessary. Yes, it may well be worth doing for something with bigger
>>> consequences, but I think that for something like this, it's just
>>> overthinking the issue.
>>
>> When it comes to ABIs, I think there *is* value in a lead time on the
>> change. This particular example is a good example of why.
>
> No. This whole example is a good example of the fact that YOU SHOULD
> NOT MAKE ABI CHANGES.
>
> I don't understand why this seems to be so hard for people to understand.
>
> There are exactly *zero* reasons to change the ABI for its own sake,
> and this whole thread is a wonderful example of how F*CKING STUPID it
> was to even consider it.

[...]

> Quite frankly, our most common ABI change is that we don't even
> realize that something changed. 

(Yes.)

> And then people may or may not notice
> it. And we've had cases where the same system call returned
> *different* things for different subsystems, and we tried to make it
> at least internally consistent.
>
> But the "premeditated ABI change just for the reason of an ABI
> change"? It's bullshit. And it's bullshit whether it shows up in
> feature-removal or not.
>
> (The whole feature-removal file is BS, for that matter, but that's a
> different issue).
>
> SO STOP DOING ABI CHANGES. WE DON'T DO THEM.
>
> The absolute worst thing a kernel can do is "change the user-level
> interfaces". It has to be done occasionally (see above), and sometimes
> we do it by mistake, but anybody who does it on purpose "just because"
> should not be involved in kernel development (or library development
> for that matter).

Agreed. As I pointed out, the reason for this proposed change is 
dubious at best. There is no "spec" on this point. And though I 
didn't mention it (since it seemed obvious), no one has mentioned 
any user-space hardship because of current behavior.

Given the choice of (1) no change, (2) making the proposed dubious 
change, or (3) making a change to make Linux consistent with other 
systems, (1) is obviously the best in this case. The only thing that 
surprised me was that you and Thomas merged this proposal into 
feature-removal-schedule.txt, which seemed to indicate an agreed 
intent to change the ABI (i.e., discarding option (1)), and
if so, I wanted to point out that proposed direction was wrong.

Patch follows.

Thanks,

Michael

