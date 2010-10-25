Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab0JYFOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 01:14:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37248 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0JYFOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 01:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type:content-transfer-encoding;
        b=vDVuvk7YONyjcn6L23cwlaoPiyTFYr49slzRWqgvttAJqFxk9Xl/l9MCQyCUqI2Jv9
         Qb8f27S11BbbCCtk3qB9Gg/sY0kxfze9HAq6L5iPzt5P/4ayx1nNOcosDk/Oiw+dNGVZ
         ZuRgGVJvjJuPvX8QBzwLnrKRgPQudP6rmnGQo=
MIME-Version: 1.0
From: Luke Hutchison <luke.hutch@mit.edu>
Date: Mon, 25 Oct 2010 01:13:35 -0400
X-Google-Sender-Auth: GFXeuMMbKOtWGp2CMC6FHifcY-Q
Message-ID: <AANLkTinZQJPwZdg9GT1VLm-+cyXK8DoL8W9quRszwJZF@mail.gmail.com>
Subject: kernel bug?: Reopening a browser session with many tabs seems to shut
 down networking stack
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Toshiba Satellite Pro S300M-S2142 laptop with a Core 2 Duo
P8600 CPU, Intel GM45 gfx, Intel 82567V Gigabit Ethernet and Intel
5100 Wifi.  Since around Linux kernel 2.6.33 or so (but maybe as early
as 2.6.31, not sure exactly what version), when restoring a crashed or
closed browser session of either Firefox or Chrome where lots of tabs
(say 10-40) open simultaneously, the networking stack is brought to
its knees -- most or all the tabs eventually time out without data, or
a few tabs might get some data and then display a partial web page.
Sorry for the length of the following bug report, but it's quite hard
to describe the behavior succinctly.

Even after all tabs have timed out, it's impossible to get data by
opening a new tab -- nothing seems able to access the network
connection.  Networking is broken for other processes too -- for
example, if it is a Chrome session that is restarted and times out,
then subsequently Firefox is not able to access the network, and
commandline tools like ping don't work either.  The connection still
shows as up in NetworkManager, and sometimes after 5-10 minutes goes
back to normal, but not always. "service network restart" and/or
"service NetworkManager restart" sometimes fixes the problem, but
sometimes normal network activity isn't restored until a reboot.

Also sometimes (but not always) whatever the network stack on my
laptop is doing is funky enough to screw up my home router, which has
to be reset to get the connection back to full speed again.  However
it is not a router problem in general, because:

(1) all these symptoms (except this last one where the router somehow
gets screwed up by the laptop's odd behavior) are present whether I
use a wired or wireless connection, and regardless of which network I
am connected to (home or anywhere else, or even when tethered to my
Nexus One); and

(2) I used to be able to reopen a closed browser session with 40 tabs
and they would all load up just fine.  Then at some point after a
Rawhide update, this broke.
I can't put my finger on exactly when this broke, because I was
dealing with worse breakage for a while since Fedora kernel 2.6.31.5,
as I reported at the following link:

https://bugzilla.redhat.com/show_bug.cgi?id=555213#c1

Basically in the very same situation (opening lots of browser tabs),
the machine would lock up hard and the fan would immediately blow at
100% speed.  It took a couple of months of Rawhide updates for this
bug to go away, but by the time this lockup bug was fixed around the
release of Fedora 13 at kernel version 2.6.33, the other network
issues I have described above became evident, triggered in the same
way -- thus I believe the two bugs may be related somehow.

My computer has been close to unusable for moderate browsing activity
for about 8 months of the year so far, across nearly two releases of
Fedora (F13 and F14 beta).  I filed the above bug report but it was
never commented on by RedHat engineers.  I figured the bug was
probably visible enough that somebody else should notice it and I just
kept hoping the next update would contain a fix, but not yet.

I don't know if this is a Fedora-specific bug but figured I should
report it upstream too.  Please advise me as to how to debug this
problem further.  (I haven't seen anything that looks suspicious in
dmesg output or /var/log/messages, to start with.)

Thanks,
Luke Hutchison
