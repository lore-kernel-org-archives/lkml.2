Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab0JaRtp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:49:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39623 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab0JaRtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=hmvjGiT14/5ToDXGrfa9oFb8HLiZrZbShpgzbPkn4pslNVjIWIe5/sp4Gq9Ij47WAG
         sClZN+dxoXhZFN8whbziyBUG39bjLVNCkIYwgY5JEDkHMaA1Ru3qNiHoSewzHU0oSvqo
         pfo85n7V0NIyy7KuWxGFSak1rh44yCMTXcJVE=
MIME-Version: 1.0
In-Reply-To: <20101031023145.GB1869@thunk.org>
References: <AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
	<20101028090002.GA12446@elte.hu>
	<AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
	<20101028133036.GA30565@elte.hu>
	<20101028170132.GY27796@think>
	<AANLkTikgO=n88ZAQ6EYAg1+aC1d0+o923FYyhkOouaH5@mail.gmail.com>
	<20101029145212.GA21205@thunk.org>
	<AANLkTim-A7DLOOw4myQU3Lfip+ZEE32F2Ap_PJXuxG6G@mail.gmail.com>
	<20101030091440.GA15276@elte.hu>
	<AANLkTim-hgA3-9T_N5k53Sga5LMazMQPmmQZzQsoQvRY@mail.gmail.com>
	<20101031023145.GB1869@thunk.org>
Date: Sun, 31 Oct 2010 18:49:39 +0100
Message-ID: <AANLkTimc4wphG4BXv=rN8MVvFDhnkjtWn_hgHzyJVucw@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Aidar Kultayev <the.aidar@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 3:31 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sat, Oct 30, 2010 at 07:02:35PM +0600, Aidar Kultayev wrote:
>> the system is/was doing :
>> .dd if=/dev/zero of=test.10g bs=1M count=10000;rm test.10g
>> .netbeans
>> .compiling gcc-4.5.1
>> .running VBox, which wasn't doing any IO. The guest os was idle in other words
>> .vlc
>> .chromium
>> .firefox
>> and bunch of other small stuff.
>>
>> Even without having running DD, the mouse cursor would occasionally
>> lag. The alt+tab effect in KWin would take 5+seconds to workout.
>> When I run DD on top of the workload it consistently made system much
>> more laggy. The cursor would freeze much more frequent. It is like if
>> you drag your mouse physically, but the cursor on the screen would
>> jump discretely, in other words there is no continuity.
>> Music would stop.
>
> If you start shutting down tasks, Vbox, netbeans, chromium, etc., at
> what point does the cursor start tracking the system easily?  Is the
> system swapping?  Do you know how to use tools like dstat or iostat to
> see if the system is actively writing to the swap partition?  (And are
> you using a swap partition or a swap file?)
>
> The fact that cursor isn't tracking well even when the dd is running,
> and presumably the only source of I/O is the gcc and vlc, makes me
> suspect that you may be swapping pretty heavily.  Have you tried
> investigating that possibility, and made sure it has been ruled out?

Something to try is also to raise X cpu scheduling priority, since I
would be really surprised if we evict from memory the routine that
draws the cursor.
BTW, I've seen the cursor jumping problem even when not swapping, and
with minimal *real* disk activity (but with heavy usage of a fuse
filesystem providing remote resources), and high cpu activity.
Raising X priority solved the problem with the mouse pointer, but the
gui programs still didn't respond quickly...

Thanks
Corrado

>
>                                                - Ted
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
