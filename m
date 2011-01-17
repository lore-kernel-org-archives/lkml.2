Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1AQHLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 02:11:22 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:34306 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1AQHLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 02:11:20 -0500
Message-ID: <48f447ae8623cdca64e23f05fc46ba7f.squirrel@webmail.sf-mail.de>
In-Reply-To: <20110117000558.GG22723@ZenIV.linux.org.uk>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
    <20110116141105.59e5b3a2@stein>
    <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
    <20110117000659.57352da7@stein>
    <AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
    <20110116231901.GF22723@ZenIV.linux.org.uk>
    <AANLkTikWHkfb1-Yh_O=rYEqzgz48rwRggCp6uhr+E86J@mail.gmail.com>
    <20110117000558.GG22723@ZenIV.linux.org.uk>
Date: Mon, 17 Jan 2011 08:11:17 +0100
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-scsi" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        "Joel Becker" <jlbec@evilplan.org>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "James Bottomley" <james.bottomley@suse.de>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jan 16, 2011 at 03:45:35PM -0800, Linus Torvalds wrote:
>
>> And now ask yourself, do you really expect some random user to say "I
>> want to enable SYSFS and CONFIGFS, because I am going to use ocfs2 on
>> my system"?
>>
>> Really?
>>
>> Or do you expect a high-quality implementation of a configuration
>> script to allow the user to just say "I want ocfs2", and then figure
>> out the dependencies and solve them for you?
>>
>> I'd say that the latter case is OBVIOUSLY the quality implementation,
>> while the former one is just stupid.
>
> It's a bit more complicated than that...
> 	* nitpick: config option for a driver foo should be seen only after
> foo got enabled, so that's another case where we need depends on
> 	* nitpick 2: some switchable things really shouldn't be selectable,
> or you'll get users wondering which of the drivers they'd enabled had
> lead to 32bit kernel on their amd64 boxen ;-)
> 	* all nitpicks aside, there ought to be a way to say "no, I _REALLY_
> don't want that shit doing #define if(x) <horrible pile of crap> and if it
> means that I can't have oprofile, so be it".  Without chasing tons of
> select
> chains to see which FPOS do I need to disable to get rid of the damn
> thing.
> Right now the propagation of select chains makes it more and more
> unpleasant.
>
> IOW, it would be very nice to be able to pin a select target down, turning
> selects leading to it into hard dependencies.
>
> Another obviously missing thing is that dependencies should propagate back
> through select chains.  I.e. if A selects B, then hard dependencies of B
> should append to those of A.
>
> It gets really lousy when you have shitloads of drivers spread over
> several
> Kconfig menus, all selecting an option that has a hard dependency.  As it
> is, if you want e.g. allmodconfig to produce something that builds you
> have
> to chase them all down and add dependencies to each of those drivers.  We
> have such piles in e.g. drivers/media.

This sounds _exactly_ like doing a software package selection on distro
install. "No, I don't ever want mono because even if I am then missing
$foo". And it will likely need the same handling, e.g. as zypper does it
already: you don't want to install mono, but $foo depends on it. What to
do? 1) keep mono, 2) don't install $foo. The third option zypper usually
gives (ignore those dependency) usually doesn't make any sense for kernel
stuff so we can omit that.

For menuconfig this will end up that we have something beyond y-n-m, we
need also a forced-no as we currently have auto-m and auto-y.

Eike
