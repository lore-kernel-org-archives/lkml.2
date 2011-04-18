Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1DRHeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:34:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45333 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1DRHeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:34:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ot1nSdmk1eyZ53xB/vP1A4SkFnKD0aiY9nq/wQsh10/Erub/t39Gx7ANNZ7AB2mGXJ
         MM+Yo1lpfP4Y3ZK9jNKoN2Zm68uFui2uQXcpo8OhZMDNcIAxtx8WAYugg0ChHApScpj3
         mkK2r1eVNvHWQVc0/ETXUtk4IRBZbKz7tQlfw=
MIME-Version: 1.0
In-Reply-To: <4DAA27C8.7060800@gmail.com>
References: <BANLkTi=LvyZ+7BHfVL849pztfvsYaVM4SQ@mail.gmail.com>
 <4DA9CB83.4050000@gmail.com> <BANLkTi=avo9yvpQ0VRPRv1uroF3ZnJzfAg@mail.gmail.com>
 <4DAA27C8.7060800@gmail.com>
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Mon, 18 Apr 2011 09:34:24 +0200
Message-ID: <BANLkTikihzxtp9ep3dE1zpPGKUGm1gij8Q@mail.gmail.com>
Subject: Re: [Regression] Bluetooth pairing does not work anymore in
 2.6.39-rc3 (works in 2.6.38.3)
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        padovan@profusion.mobi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I checked: I have this commit in -rc3, so it must be something else here.
> hmm... seems to be working over here with the latest Mainline. one thing  I
> have notice though is the daemon is not starting during boot(systemd),
> manually starting bluetoothd gets me to connect.(system is fedora 15).

It was my fault after all:

I had based my kernel config on 2.6.39-rc2 from Ubuntu's
mainline-kernel PPA, and this doesn't have BT_L2CAP..

Case closed.


I am just wondering: is it possible to make BT_L2CAP (and SCO?)
default to yes when BT is compiled in or build as a module?

>From commit 6427451: "The L2CAP layer is needed by almost all
Bluetooth protocols and profiles. There isn't any real use case
without having L2CAP loaded." Yet when I am doing oldconfig from a
config that had L2CAP build as a module, I am getting these easily
overlooked lines:

L2CAP protocol support (BT_L2CAP) [N/y/?] (NEW)
SCO links support (BT_SCO) [N/y/?] (NEW)


cheers,
gohai
