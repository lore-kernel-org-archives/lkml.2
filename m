Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab0LMScA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:32:00 -0500
Received: from mail-iw0-f180.google.com ([209.85.214.180]:39422 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab0LMSb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:31:58 -0500
X-Greylist: delayed 3910 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 13:31:58 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=HTvtykGCUOpOivLgLbWdIImf3upSY+dF2uCdK8O5Advibr8LQoiBtlDjQ46XlGO9Fo
         G4Ovdu8jf4pqTOzd/3uDf/scQzCQRW4m3Bi9N+/0zkfMhsqYVitGv3jXRDho07MDbfIi
         18KoXwMITXbjCFkjnfzGk15Uo7rbOhtKqyPkk=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Dec 2010 10:31:34 -0800
Message-ID: <AANLkTimNe0wX1cJfw3zdTpa5pqZ-xycWVtp4tH4auaCc@mail.gmail.com>
Subject: Stable extra versions on linux-next.git
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

I'm using linux-next.git to suck out pending stable patches for some
releases for 802.11 using compat-wireless. This works great for the
first stable release of a kernel, so for example 2.6.36 was released
but there were a few stable patches I wanted to suck in for a release
for compat-wireless-2.6.36 so I used linux-next.git and used this:

git format-patch --grep=stable@kernel.org -o pending-stable/ v2.6.36..
        net/wireless/
        net/wireless/
        net/mac80211/
        net/rfkill/
        drivers/net/wireless/
        net/bluetooth/
        drivers/bluetooth/
        drivers/net/atl1c/
        drivers/net/atl1e/
        drivers/net/atlx/
        include/linux/nl80211.h
        include/linux/rfkill.h
        include/net/cfg80211.h
	include/net/mac80211.h
        include/net/regulatory.h
        include/net/cfg80211.h

To suck out pending-stable patches so I can apply to my local tarball.
I just noticed linux-next.git doesn't suck in the stable extra
versions though. The extra version stable updates are available
through hpa's linux-2.6-allstable.git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git

Now, I have three trees:

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git

My wireless-testing.git tree is the original fresh clonse, all others
are cloned with --reference pointing to the wireless-testing/.git
directory. This lets me removes the need to suck in objects which all
trees have in common. What it seems I want is to generate a
format-patch from one old stable-extra-version to a new linux-next
tag.

git format-patch --grep=stable@kernel.org -o pending-stable/
v2.6.36.2..next-20101213

I tried this from my wireless-testing directory but with no luck, it
doesn't know about the linux-2.6-allstable.git tags and linux-next.git
tags, and my linux-next tree tree is unaware of the extra version
stable updates. Any ideas if I can get this working somehow?

  Luis
