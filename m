Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1EPRGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:06:31 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:62744 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1EPRGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YzfwznWfLyYFRBY3scencVkh6+FwAdl+34i9+HxLLW6R3bHGxlBLH75WbOvWXAbD57
         1hY0QfujB+58QDRM8NM/ETCaT5+drvEU9s2gT49JM75hZr07h6w3kA5ykVCydfsDVKul
         /qHJt60e8cQzgrC5cYRnmlLsXXVwyJc4104gQ=
MIME-Version: 1.0
In-Reply-To: <20110516160810.GB25898@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
 <1305329059-2017-5-git-send-email-andi@firstfloor.org> <20110514065752.GA8827@elte.hu>
 <20110514163424.GU6008@one.firstfloor.org> <4DD14814.8080305@mit.edu> <20110516160810.GB25898@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 16 May 2011 13:06:10 -0400
X-Google-Sender-Auth: KvTTlSmjgu4sOfjzQRvJzqVE6-c
Message-ID: <BANLkTikDX0G5EWZ7w1Ob_7YBZpA5xDvGQw@mail.gmail.com>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 12:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> You could also add a vsyscall function and have that function pull the
>> values from vvar data.  It would be very fast (i.e. almost as fast as
>> mmaping some data) and it would be more portable.
>
> vvar is a global. The variable data in sysconf is per thread
> (and not even per mm)
>
> Even if you ignore the semantic problem of thread versus mm, you would
> need a new writable page per process and update it any time
> the rlimits and other information is updated.
>
> On the other hand my solution is dead simple and already solves
> the problem.

True.  I should read the entire list of variables before making
suggestions that won't work.  :)

--Andy

>
> -Andi
>
