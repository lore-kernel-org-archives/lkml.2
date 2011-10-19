Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1JSXbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:31:13 -0400
Received: from tango.0pointer.de ([85.214.72.216]:52053 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1JSXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:31:12 -0400
Date: Thu, 20 Oct 2011 01:31:11 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Paul Menage <paul@paulmenage.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111019233111.GE32295@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
 <20111019230347.GA32295@tango.0pointer.de>
 <CALdu-PCRj4+tL-6MXwsZKuODHRQn_pixdfVLwC6PV2a0q4sw4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdu-PCRj4+tL-6MXwsZKuODHRQn_pixdfVLwC6PV2a0q4sw4g@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19.10.11 16:09, Paul Menage (paul@paulmenage.org) wrote:

> On Wed, Oct 19, 2011 at 4:03 PM, Lennart Poettering
> <mzxreary@0pointer.de> wrote:
> >
> > For our systemd usecase a cgroup.signal file would not be useful. This
> > is because we actually kill all members of the service's cgroup plus the
> > main process of the service, which is usually also in the service's
> > cgroup but sometimes isn't (for example: when the user logs in, the
> > whole /sbin/login process ends up in the user's session cgroup, and is
> > removed from the original service cgroup). Since we want to avoid
> > killing the main service process twice in the case where it isn't in the
> > servce cgroup we'd hence prefer to have some fork throttling logic in
> > place, so that we can kill members flexibly in accordance with these
> > rules.
> 
> By fork-throttling, do you just mean "0 or unlimited", or would you
> actually want some kind of rate-limited throttling? If the former,
> than I agree with Frederick that his task counter should solve that
> problem.

Given that shutting down some services might involve forking off a few
things (think: a shell script handling shutdown which forks off a couple
of shell utilities) we'd want something that is between "from now on no
forking at all" and "unlimited forking". This could be done in many
different ways: we'd be happy if we could do time-based rate limiting,
but we'd also be fine with defining a certain budget of additional forks
a cgroup can do (i.e. "from now on you can do 50 more forks, then you'll
get EPERM).

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
