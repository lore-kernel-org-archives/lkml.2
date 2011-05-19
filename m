Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222Ab1ESTVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:21:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44552 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab1ESTVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:21:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HsfUvf7vFqoj7ETAmRDSXqvkET8zj6AlcW+ZwcrNg5ZEar8gxaAFZcOc90bZmzTEuy
         auY2xlGAoxZ8jo0mRKakRXso2NyTAAkQSf2yl1Pp6+GhbRPCxNZaG2bNLv815gph1S4E
         vAKR3VL2CaqXGNTuHmq+MldmgD61QMpToNoG4=
MIME-Version: 1.0
In-Reply-To: <20110519181931.GA22506@redhat.com>
References: <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com>
 <20110426194904.GC8520@redhat.com> <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
 <20110513164435.GA22435@redhat.com> <BANLkTimGjunaA4Fzdo6dc5=cKTc_g90j5Q@mail.gmail.com>
 <20110516125702.GA7941@redhat.com> <20110516125728.GB7941@redhat.com>
 <20110518163725.13e816fe.akpm@linux-foundation.org> <20110519181931.GA22506@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 19 May 2011 15:21:23 -0400
Message-ID: <BANLkTimjP1t9Qycwc7iVnssi0YDpVAZL7Q@mail.gmail.com>
Subject: Re: [PATCH v2] signal: trivial, fix the "timespec declared inside
 parameter list" warning
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 14:19, Oleg Nesterov wrote:
> On 05/18, Andrew Morton wrote:
>> On Mon, 16 May 2011 14:57:29 +0200 Oleg Nesterov wrote:
>> > --- sigprocmask/include/linux/signal.h~15_stw_warning       2011-05-12 20:44:43.000000000 +0200
>> > +++ sigprocmask/include/linux/signal.h      2011-05-16 14:53:08.000000000 +0200
>> > @@ -234,6 +234,9 @@ static inline int valid_signal(unsigned
>> >     return sig <= _NSIG ? 1 : 0;
>> >  }
>> >
>> > +struct timespec;
>> > +struct pt_regs;
>> > +
>> >  extern int next_signal(struct sigpending *pending, sigset_t *mask);
>> >  extern int do_send_sig_info(int sig, struct siginfo *info,
>> >                             struct task_struct *p, bool group);
>>
>> Please put the forward declarations at top-of-file.  In this case,
>> inside #ifdef __KERNEL__.  This reduces the risk of accumulating
>> duplicated forward declarations, as has happened in the past.
>
> This is what Mike suggested from the very beginnig. Perhaps this
> would be better but since I already applied this patch... I'd prefer
> to not test my git skills, unless you or Mike object.

i'm ok with this version as it's at the top of the existing prototype
block.  Andrew's version also would work of course.
-mike
