Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab0JZS6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:58:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49833 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0JZS6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LSRt1XciGBomlEDlRDvKmOqTPwqLqDCu6+XVK99H9zw4e6oUVpyZYNr1TjaDHnTUZ8
         /gte/luKSXmRmqFIie232mlN5YhlsiWLlA4knXFByo7Rh4VFEan7dfy63BLDdPzZB8EJ
         Hd08Z/k0St0KHfkXv02KZ+Xh4ScId0GID1uQI=
MIME-Version: 1.0
In-Reply-To: <20101026184123.GA1616@sig21.net>
References: <20101025190358.AEC6840F97@repository3.orbit-lab.org>
 <20101026123552.GA4604@sig21.net> <AANLkTimzUKj=C9PxGs1PkQy_KWu0PGKd1zv_m-ZpWaEm@mail.gmail.com>
 <20101026184123.GA1616@sig21.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Oct 2010 11:51:01 -0700
Message-ID: <AANLkTimHpyJho6AheQc6zos7Pmr-ECjvaL83mYDC19Yd@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-10-25 is baked
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivo Van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 11:41 AM, Johannes Stezenbach <js@sig21.net> wrote:
> On Tue, Oct 26, 2010 at 08:59:04AM -0700, Luis R. Rodriguez wrote:
>> On Tue, Oct 26, 2010 at 5:35 AM, Johannes Stezenbach <js@sig21.net> wrote:
>> >
>> > I wonder about the different tarballs in
>> > http://wireless.kernel.org/download/compat-wireless-2.6/
>> >
>> > compat-wireless-2010-10-25.tar.bz2
>> > compat-wireless-2010-10-25-p.tar.bz2
>> > compat-wireless-2010-10-25-pc.tar.bz2
>> >
>> > Those -p and -pc postfixes are not explained in
>> > http://wireless.kernel.org/en/users/Download
>>
>> Right, sorry, I haven't updated the docs to add documentation for
>> them. First please read:
>>
>> http://marc.info/?l=linux-wireless&m=128716953726075&w=2
>>
>> -s is for getting and applying pending-stable/ fixes
>> -n is for applying the patches linux-next-cherry-picks directory
>> -p is for applying the patches on the linux-next-pending directory
>> -s is for applying the patches on the crap directory
>  -c
>
>> Hope this helps.
>
> Definitively, thank you very much.  Meanwhile I also found
> scripts/admin-update.sh in compat-wireless which seems to
> generate the release tarballs.
>
> It looks like, if I want to test the latest rt2x00 code, I could
> clone git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git,
> checkout experimental, and then run admin-update.sh with
> GIT_TREE=path/to/rt2x00-experimental.  Right?

Yeap, if rt2x00-experimental is based on linux-next.git. If its based
on wireless-testing.git then you can use the "wl" branch of
compat-wireless, but I tend to not keep that as up to date as the
linux-next.git branch so likely the "wl" branch doesn't apply cleanly
right now with wireless-testing.git as the GIT_TREE.

> Or (maybe better?), clone linux-next, merge rt2x00.git and use
> the merged tree as GIT_TREE for admin-update.sh.

It just depends on the original tree is a clone from and what branch
you use on compat-wireless. The master branch is for linux-next.git,
the "wl" branch is for wireless-testing.git. Every now and then I just
reset the "wl" branch (you'll have to 'git reset --hard wl') to the
master branch and revert any patches that do not apply.

> Well so just
> But according to
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-October/002175.html
> the compat-rt2x00 tarballs seem to be made manually?

Too lazy to check that, best thing might be to just focus on upstream
development, ensuring patches get into linux-next.git and having your
users just use the daily tarballs and stable releases for stable
stuff.

> Sorry for stupid questions, I want to get into rt2x00 development
> but I need to target a stable 2.6.32 kernel and I'm trying to figure
> out which git tree to base my work on.

My advice, work on wireless-testing.git, send patches ASAP, and let
them propagate. Use the daily tarballs for user testing and for stable
release you can support users using the stable compat-wireless
releases.

Hope this helps.

  Luis
