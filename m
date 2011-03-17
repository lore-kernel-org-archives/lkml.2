Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1CQSjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:39:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45745 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab1CQSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NG9SfXnKxGIoEuZC/ZEfbK5Y7suG6KYKBIJ84UAZ4Mqi6k+65d+3qVMg0n29pO4sPl
         Otmof59IL0oD2z8g4obS3RLO1fdpmQgC0iv8/l3+Ax0adve31S2rK7Cfy8q/tKLYmuZd
         tLkVBbk734tAteJU4e4HxWBxGE3RghKNxIAu0=
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
In-Reply-To: <AANLkTim4hY_HJrukNjVe5RDzBj7r547BcxKRozKcQ_uE@mail.gmail.com>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	 <1300370936.16880.96.camel@gandalf.stny.rr.com>
	 <AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	 <1300380909.16880.264.camel@gandalf.stny.rr.com>
	 <1300381340.6315.323.camel@edumazet-laptop>
	 <1300385802.16880.348.camel@gandalf.stny.rr.com>
	 <AANLkTim4hY_HJrukNjVe5RDzBj7r547BcxKRozKcQ_uE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 19:38:42 +0100
Message-ID: <1300387122.6315.407.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 mars 2011 à 19:25 +0100, Geert Uytterhoeven a écrit :
> On Thu, Mar 17, 2011 at 19:16, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 2011-03-17 at 18:02 +0100, Eric Dumazet wrote:
> >> Le jeudi 17 mars 2011 à 12:55 -0400, Steven Rostedt a écrit :
> >> > Here, test this patch. I'm in the process of committing it now.
> >> > It will be two patches, one for the WARN_ON_SMP() change, the other for
> >> > the futex change.
> >> >
> >> > -- Steve
> >> >
> >> > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> >> > index c2c9ba0..25f1e9e 100644
> >> > --- a/include/asm-generic/bug.h
> >> > +++ b/include/asm-generic/bug.h
> >> > @@ -168,7 +168,7 @@ extern void warn_slowpath_null(const char *file, const int line);
> >> >  #ifdef CONFIG_SMP
> >> >  # define WARN_ON_SMP(x)                    WARN_ON(x)
> >> >  #else
> >> > -# define WARN_ON_SMP(x)                    do { } while (0)
> >> > +# define WARN_ON_SMP(x)                    ({0;})
> >> >  #endif
> >> >
> >>
> >> You meant :
> >>
> >> # define WARN_ON_SMP(x)                       ({x;})
> >>
> >> or
> >>
> >> # define WARN_ON_SMP(x)         do { } while (x, 0)
> >>
> >> ?
> >>
> >
> > Does if (do { } while (x, 0)) work?
> 

My point was that WARN_ON(X) always evaluates X once

And apparently, WARN_ON_SMP(X) doesnt evaluates X iF !SMP

This should be documented, or fixed ;)



