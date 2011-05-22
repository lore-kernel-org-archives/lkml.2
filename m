Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1EVIP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 04:15:29 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:52263 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1EVIPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 04:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=O6kJZ2487FIP1GB8APajFvtntUfU7xGv7HLJjDq5qpPShBzY/4HDcfaNHWK9QbEYng
         9ajoOH4wynZgdIRhjUaDHMsfqUArsCjQe7ZJrgWSkjLfcIrpFXOIjAO5+ihM3HMEGmC/
         REkO31r/uyttCBbYDgOYsXnREYaEKjWJWm6CQ=
MIME-Version: 1.0
Date: Sun, 22 May 2011 10:15:23 +0200
X-Google-Sender-Auth: 5cecRRmdtJhxmHrHpnT9BqfrqTc
Message-ID: <BANLkTikf7M_yTFe2fZx63HSDYFjhT_+soA@mail.gmail.com>
Subject: Adding syscalls (was: Re: [GIT PULL] Namespace file descriptors for 2.6.40)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 02:33, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> On Sat, May 21, 2011 at 4:39 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> In a hopeless quest to avoid conflicts when merging a new system call
>>> and wiring it up I have pulled in bits of net-next and the parisc tree.
>>> You have already pulled the net-next bits.  The parisc bits in my tree
>>> are:
>>
>> Ok, this just means that I won't pull from you.
>
> Sure.  I will try to be a little more patient and resend the pull
> request after James has sent the pull request for the parisc tree.
> At which point the only unique changes in my tree will be mine.
>
>> It's that simple. We don't do this. Ever.
>
> Hah. I seem to remember bits of pulling from non-rebasing trees being ok
> in well defined contexts.  This seems like one.  Especially when you
> have checked with the maintainers.
>
> Plus all of the parisc bits in addition to being in the linux-next
> are trivially correct.
>
>> Why the hell did you even worry about wiring up parisc system calls?
>> That's not your job.
>
> Because in general it is the job of he who changes something to fix up
> every possible place.
>
> Now maybe I went a little too far in trying to resolve the conflicts,
> but I did check with the David Miller and James Bottomley and they knew
> what I was doing.
>
> Quite honestly adding system calls is a mess that know one seems to
> know how to do right.  So I flipped a coin and took a stab at it.

At first, I was delighted to see that somebody took care of adding
syscalls to the
non-popular architectures.

At second, I saw the conflicts in e.g. parisc and m68k due to this.

Hence now I think it's better to leave the wiring up to the
architecture maintainers, as
before.
I'm even thinking to suggest to first let go in the syscall (without
any wiring up, not
even on x86), and let all wiring up be handled afterwards. This would
enforce that
syscalls numbers are not cast in stone, until they hit mainline.

This does mean that scripts/checksyscalls.sh needs to be changed, as initially
new syscalls aren't wired up there neither. The implementation of the
syscalls needs
to announce somehow that it's there and that it's a syscall.

What do you think?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
