Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab2GFWFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:05:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49513 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab2GFWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120706203825.20ce3e47@pyramind.ukuu.org.uk>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
	<20120706203825.20ce3e47@pyramind.ukuu.org.uk>
Date: Sat, 7 Jul 2012 01:05:21 +0300
Message-ID: <CAGoecWxymi-jrTO5AdeYRMkbqdrk6je9xaUKmBry=LGqNC-D0w@mail.gmail.com>
Subject: Re: Regression - /proc/kmsg does not (always) block for 1-byte reads
From: Jukka Ollila <jiiksteri@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, kay@vrfy.org, jbeulich@novell.com,
        greg@kroah.com, torvalds@linux-foundation.org, joey@debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 10:38 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 6 Jul 2012 20:45:44 +0300
> Jukka Ollila <jiiksteri@gmail.com> wrote:
>> A few days ago I filed a kernel regression report concerning a change
>> in /proc/kmsg behaviour with short reads:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=44211

>> I don't know what other distros do. Is it just Debian being the odd one out?
>
> If this is observed on an actual standard distro userspace and breaks it
> then its a regression and it needs fixing or reverting.

Now this got me wondering if Debian _unstable_ actually qualifies as a
standard distro userspace.

And I did a little digging. According to the Debian package tracking
system[1] it would seem that the _stable_ distro carries a version
that doesn't do the dd shuffling at all and probably runs its klogd as
root, reading /proc/kmsg directly. That may or may not work with
3.5-rc kernels, depending on how big its reads are. I'm CCing the
listed maintainer just in case.

The unstable version does the problematic dd bs=1 trick. Also the
Ubuntu diff in the PTS has the dd. But I have no idea how Ubuntu does
it's release management. Not to mention other derivatives.

So it might not be too late to fix this in userspace, in case the
kernel wants to move on. Some real distro people might want to chime
in.

Thanks,

-J

[1] http://packages.debian.org/search?keywords=sysklogd
