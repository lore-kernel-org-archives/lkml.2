Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0H3FV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 01:21:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59265 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab0H3FV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 01:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=JR2PH72eY8M7lnKAogXpweRjc8kmvv7KB0FqeoTOnVHKWA4txM5AMz0WpFUPTKT1YN
         HO1J6KzBcJYwsRFfHDv/ktdhgbPqs4QFc1Ks3icLK0YS1PONkvXhi9t3Ipy81qph+Ym4
         7zwQtwrVhG/SH/DrL8iWJAsQOWavxKZ++xvyY=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902041600170.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
 <20090204150507.665b5b7c.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
 <20090204152434.c8f65d52.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
 <20090204155514.6abbdc8f.akpm@linux-foundation.org> <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
 <alpine.DEB.1.10.0902041600170.6214@alien.or.mcafeemobile.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 30 Aug 2010 07:21:05 +0200
Message-ID: <AANLkTim_seWr0LZJyC+dPBy-N+_NkzTx21vte7qrwunC@mail.gmail.com>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 2:02 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Thu, 5 Feb 2009, Michael Kerrisk wrote:
>
>> > Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
>> > that work in this case?
>>
>> As youll have seen by now, Ulrich and I noted that it works.
>>
>> > If so, it would be sensible to mention this in
>> > the description somewhere as the approved probing method and to
>> > maintain it.
>>
>> I'll add something to the man page, as this patch progresses.
>
> I see we already have stuff like this inside the man pages:
>
> O_CLOEXEC (Since Linux 2.6.23)
>          Enable the close-on-exec flag for the new file descriptor.
>          ...
>
> Maybe a similar note for the new flag?

It took a while, but here's the new text in the eventfd.2 (will be in
man-pages-2.36). Could you please ACK, Davide?

       EFD_SEMAPHORE (since Linux 2.6.30)
              Provide semaphore-like semantics  for  reads  from
              the new file descriptor.  See below.
...
              *  If EFD_SEMAPHORE  was  not  specified  and  the
                 eventfd  counter  has  a  nonzero value, then a
                 read(2) returns 8 bytes containing that  value,
                 and the counter's value is reset to zero.

              *  If  EFD_SEMAPHORE was specified and the eventfd
                 counter has a nonzero  value,  then  a  read(2)
                 returns 8 bytes containing the value 1, and the
                 counter's value is decremented by 1.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
