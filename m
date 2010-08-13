Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228Ab0HMByq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 21:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab0HMByp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 21:54:45 -0400
Subject: Re: 2.6.36: Sound stop working
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimesXb7Ut3aO71HjmNjV_Q53p0Jr5j4kLTwsRGh@mail.gmail.com>
References: <201008122200.05598.thomas@m3y3r.de>
	 <AANLkTikZ4wA4jJ0AnWMXYmgWVBShRW=Yu67J0QvebRx0@mail.gmail.com>
	 <s5hpqxntw64.wl%tiwai@suse.de> <4C646110.1040104@gmail.com>
	 <s5hbp97ttt5.wl%tiwai@suse.de>
	 <AANLkTi=s-KFuUnmNaDN6OYaiwZiaBLbYB5MCwde7tvvw@mail.gmail.com>
	 <20100812215246.GK31363@ZenIV.linux.org.uk>
	 <AANLkTimesXb7Ut3aO71HjmNjV_Q53p0Jr5j4kLTwsRGh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 21:53:51 -0400
Message-ID: <1281664431.2996.60.camel@dhcp231-200.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 15:19 -0700, Linus Torvalds wrote:
> On Thu, Aug 12, 2010 at 2:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Thu, Aug 12, 2010 at 02:41:51PM -0700, Linus Torvalds wrote:

> > I'll see what can be done to fix that mess more or less right way...
> 
> .. but I assume you don't wan tto keep those "struct file" games in
> fanotify regardless, right? So we can fix the sound issue by the
> revert I sent out, no?

Sorry I'm just coming into this now that it is 'solved.'  I just got
back to my hotel from Linuxcon and haven't been checking e-mail.  I
guess noone (including me) is testing sound in linux-next   :(.  I
wonder what kind of tom foolery it must be doing with f_count (like I
am) to have hit problems.

I certainly agree the revert patch you sent should be applied if the
worst artifact for calling dentry_open() with an 'arbitrary dentry' is
that it fails.

An easier long term fix might be a 'dentry_open_as' which I can call in
the context of the original opening process but which will be done (for
security/accounting/fd table/etc purposes) as the process which will
ultimately consume the new struct file.  I don't know which would be
better/easier for the VFS, Al?

-Eric

