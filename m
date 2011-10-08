Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1JHUxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:53:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38137 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753091Ab1JHUxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:53:48 -0400
Message-ID: <1318107227.1844.25.camel@Joe-Laptop>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for
 dynamic_pr_debug
From: Joe Perches <joe@perches.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jim Cromie <jim.cromie@gmail.com>, jbaron@redhat.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Date: Sat, 08 Oct 2011 13:53:47 -0700
In-Reply-To: <CAO+b5-phx1S5cC91Czjhmym_tAWVGwqaBavhSnwHcuKaK662ag@mail.gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com>
	 <1316725066.29447.16.camel@Joe-Laptop>
	 <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com>
	 <1317166589.19340.14.camel@Joe-Laptop>
	 <CAJfuBxyZ63mi_onv8uWc3MCGgKDPfQMOgUOT7isJ-hA=o7sfqA@mail.gmail.com>
	 <1317185489.19340.22.camel@Joe-Laptop>
	 <CAO+b5-phx1S5cC91Czjhmym_tAWVGwqaBavhSnwHcuKaK662ag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-08 at 21:07 +0200, Bart Van Assche wrote:
> On Wed, Sep 28, 2011 at 6:51 AM, Joe Perches <joe@perches.com> wrote:
> > I think all of the '#define pr_fmt(fmt) KBUILD_MODNAME ": "'
> > are effectivly useless and I will eventually delete them.
> >
> > The printk subsystem should look up the module name and
> > prefix them to the printk akin to how the dynamic_debug
> > system does.  Except the module name should be a singleton.
> 
> Shouldn't pr_*() equivalents be introduced for sdev_printk(),
> scmd_printk(), starget_printk() and shost_printk() before elimination
> of pr_fmt() can start ?

I don't think that's necessary.
Is there a reason you might think there is?

I don't think there's anything wrong with
<subsystem>_printk uses.  Those subsystems
don't have to use pr_fmt and can prefix
whatever is appropriate.

The scsi logging substem uses sdev_printk,
scmd_printk, starget_printk, and shost _printk.
All of these are mapped to dev_printk and so
don't use pr_fmt.

I did send a patch a few months ago
https://lkml.org/lkml/2011/7/9/14
to reduce text use by some of those.


