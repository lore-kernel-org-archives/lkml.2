Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1FVCn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:43:56 -0400
Received: from ozlabs.org ([203.10.76.45]:39253 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757504Ab1FVCnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:43:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
In-Reply-To: <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au> <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au> <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Wed, 22 Jun 2011 11:30:12 +0930
Message-ID: <87r56m8w2b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 00:47:55 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Jun 21, 2011 at 03:53, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Sorry, that's another vague answer :(
> >
> > udev already knows about module load
> 
> Not for built-ins.

OK, I re-read your commit message, and down the bottom it does say what
it *does*:

>        This adds the currently missing /sys/module/<name>/uevent files
>        to all module entries.

I apologize for skimming, but this should be the *title* of the patch!

Then I saw your patch hit params.c and thought you were adding a uevent
file to /sys/module/<name>/parameters/.  I was even more confused when
you replied:

> Hook system management into module-load events, which might include
> changing module parameters in /sys/module/*/parameters/*...

Because loading a module might *create* module parameters, but it won't
*change* them.  If we want to have events for change, we need much
more...

Now we've got that sorted, is there a reason why you changed all the
signatures rather than just using mod->mkobj in store_uevent()?

Thanks,
Rusty.
