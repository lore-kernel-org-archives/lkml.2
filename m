Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2GHAeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 20:34:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2GHAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 20:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAGoecWxymi-jrTO5AdeYRMkbqdrk6je9xaUKmBry=LGqNC-D0w@mail.gmail.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
 <20120706203825.20ce3e47@pyramind.ukuu.org.uk> <CAGoecWxymi-jrTO5AdeYRMkbqdrk6je9xaUKmBry=LGqNC-D0w@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 8 Jul 2012 02:33:45 +0200
Message-ID: <CAPXgP13P+cggz7DsVzgJdMNd907O4aDbnVHCdjhg5rWJ-my2hA@mail.gmail.com>
Subject: Re: Regression - /proc/kmsg does not (always) block for 1-byte reads
To: Jukka Ollila <jiiksteri@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, greg@kroah.com, torvalds@linux-foundation.org,
        joey@debian.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 7, 2012 at 12:05 AM, Jukka Ollila <jiiksteri@gmail.com> wrote:
> And I did a little digging. According to the Debian package tracking
> system[1] it would seem that the _stable_ distro carries a version
> that doesn't do the dd shuffling at all and probably runs its klogd as
> root, reading /proc/kmsg directly. That may or may not work with
> 3.5-rc kernels, depending on how big its reads are. I'm CCing the
> listed maintainer just in case.
>
> The unstable version does the problematic dd bs=1 trick. Also the
> Ubuntu diff in the PTS has the dd. But I have no idea how Ubuntu does
> it's release management. Not to mention other derivatives.

Just a note, unrelated to fixing the issue:

/proc/kmsg can be opened many times, but it never behaved too well
when this was done.

The processes might wake up at the same time, but only one of them
gets the data. If someone does a "cat /proc/kmsg' in parallel, the
read() in dd might return 0 and dd will exit. And this is not a recent
change, it was always the case.

Using dd here is a pretty silly idea for many reasons.

Kay
