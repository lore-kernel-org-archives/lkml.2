Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1JKTQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:16:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34001 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab1JKTQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:16:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 0/4] allow freezing of tasks with netfs calls in flight
Date: Tue, 11 Oct 2011 21:19:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, trond.myklebust@netapp.com,
        smfrench@gmail.com, linux-pm@lists.linux-foundation.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, john@calva.com,
        linux-kernel@vger.kernel.org
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com> <20111011061819.GA1377@ucw.cz> <20111011060531.09bc378a@tlielax.poochiereds.net>
In-Reply-To: <20111011060531.09bc378a@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112119.06547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 11, 2011, Jeff Layton wrote:
> On Tue, 11 Oct 2011 08:18:19 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > > We've had a number of reports recently of people with NFS and CIFS
> > > mounts that were unable to suspend or hibernate their machines. Here
> > > are a couple of Fedora bugs that illustrate the problem:
> > > 
> > >     https://bugzilla.redhat.com/show_bug.cgi?id=712088
> > >     https://bugzilla.redhat.com/show_bug.cgi?id=717735
> > > 
> > > When it occurs the problem is pretty clear. We have a task that's
> > > sleeping in the kernel in TASK_KILLABLE sleep, generally waiting
> > > for a reply to come in. Often though, userspace has already taken
> > > down the interface so that reply will never come. The process then
> > > fails to freeze and the suspend fails.
> > 
> > Userspace should not take interface down for suspend (*). Why do that?
> > 
> 
> I suspect that NetworkManager does this to try and allow for the case
> where someone suspends their laptop and then wanders off to another
> network and then resumes.

That's correct.

> Either way, we still want to allow suspend and hibernate to work regardless
> of what userspace does during the process.

Very true. :-)

Thanks,
Rafael
