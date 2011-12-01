Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1LAXB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:01:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45628 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1LAXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:01:26 -0500
MIME-Version: 1.0
In-Reply-To: <1321457231-9154-2-git-send-email-jslaby@suse.cz>
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
	<1321457231-9154-2-git-send-email-jslaby@suse.cz>
Date: Thu, 1 Dec 2011 15:01:26 -0800
X-Google-Sender-Auth: 8jNVnNgVGw6QtnTGA-6Z0GvPIr0
Message-ID: <CA+8MBbJ4Tu86jSbaBRjDKfowwVE12jY3efK7QMm74e7i8aq4Hg@mail.gmail.com>
Subject: Re: [PATCH 2/5] TTY: ldisc, move wait idle to caller
From: Tony Luck <tony.luck@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of my systems (HP rx2620 - ia64) has started hanging during shutdown.
Last messages on the serial console are:

Shutting down service (localfs) network  .  .  .  .  .  .  .  .  .   done
Shutting down D-Bus daemon                                           done
Running /etc/ini

and there it hangs forever in mid word (totally repeatable stops at "ini" every
time).

git bisect blames:

commit 300420722e0734a4254f3b634e0f82664495d210
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Wed Nov 16 16:27:08 2011 +0100

    TTY: ldisc, move wait idle to caller

[Though the following commit "TTY: ldisc, wait for ldisc infinitely in hangup"
 sounds like it fits the symptoms]

Ideas?

-Tony
