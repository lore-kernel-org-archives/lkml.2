Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab0GPEks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 00:40:48 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52260 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab0GPEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 00:40:45 -0400
X-Sasl-enc: 2s9nCdoH+0qxMHIT2UHSHcYQIehZg7xfFnzpz8SDj0Lt 1279255238
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
From: Ian Kent <raven@themaw.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "autofs@linux.kernel.org" <autofs@linux.kernel.org>
In-Reply-To: <AANLkTimVzSzCl2XfWBg5HauYtIT5znxkm6M0yo_1en2b@mail.gmail.com>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
	 <20100705195837.GF5240@nowhere> <1278378690.3070.6.camel@localhost>
	 <201007061335.00264.arnd@arndb.de>
	 <202899B0-BADE-4CD0-B0E4-1A2FC99397D6@themaw.net>
	 <AANLkTimVzSzCl2XfWBg5HauYtIT5znxkm6M0yo_1en2b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 12:40:30 +0800
Message-ID: <1279255230.2968.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 02:14 +0200, Frederic Weisbecker wrote:
> 2010/7/6 Ian Kent <raven@themaw.net>:
> >
> >
> > On 06/07/2010, at 7:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> >>
> >> Well, the only use of the BKL in autofs4 is in the ioctl function. You
> >> can probably replace that trivially with a global mutex, but from a quick
> >> inspection, even that should not be needed: The only ioctl command in
> >> autofs4 that does not already seem to have adequate locking is
> >> autofs4_get_set_timeout, which is even easier to change and still harmless
> >> if you don't do it at all.
> >
> > That's right of course.
> >
> > Even this shouldn't be a problem as it is called by a single instance, per autofs mount, of the daemon only. A fair amount of effort has gone into trying to make the autofs4 module independent of the BKL over time. However I would still rather not do the change concurrently with the ioctl changes.
> >
> > Ian
> 
> 
> In any case, can we let you handle this patch for 2.6.36 inclusion?

I think it makes more sense to keep these common patches together so
Arnd probably should keep it with his series.

Ian

