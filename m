Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab1JaPPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:15:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:37857 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1JaPPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:15:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Richard Hughes <hughsient@gmail.com>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Mon, 31 Oct 2011 15:11:16 +0000 (UTC)
Message-ID: <loom.20111031T155558-924@post.gmane.org>
References: <Pine.LNX.4.44L0.1110152224461.19724-100000@netrider.rowland.org> <Pine.LNX.4.44L0.1110161018580.28864-100000@netrider.rowland.org> <20111017093401.21cd4461@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 78.86.55.77 (Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20100101 Firefox/7.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb <at> suse.de> writes:
> gnome-power-manager talks to upowerd over dbus to ask for a suspend.

Quite a few other desktops talk to upower, including XFCE, KDE and LXDE.
It's basically the only way on a modern desktop a user can put the
machine to sleep without becoming root.

> upowerd then runs /usr/sbin/pm-suspend.
> pm-suspend then runs all the script in /usr/lib/pm-utils/sleep.d/
> and the calls "do_suspend" which is defined in
> /usr/lib/pm-utils/pm-functions
> 
> Ugghh.. That is a very deep stack that is doing things the "wrong"
> way.
> i.e. it is structured about request to suspend rather than requests to
> stay awake.

Erm, that's what it was designed to do. UPower has never had any feature
requests to manage "stay-awake" functionality as upower is pretty much a
mechanism daemon, rather than a policy daemon. Certainly just writing to
/sys if /usr/lib/pm-utils/pm-functions isn't installed would be a very
sane patch to suggest, given that pm-suspend in Fedora 16 basically
doesn't do anything anymore.

UPower does have signals that tell userspace when a suspend is about to
happen, and when the computer has been resumed, and this is done using
DBus.

I think it would be a shame to have Yet Another Daemon and Yet Another
Protocol just for managing this stuff, when upower already has DBus and
tons of client support. I think adding a tiny DBus interface on upower
to manage the stay-awake functionality would make things much less
complicated and give us a common desktop / embedded story.

Richard.

(please cc me in any replies, not subscribed)


