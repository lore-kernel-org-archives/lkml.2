Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2GRJzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:55:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47452 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2GRJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:55:23 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2f24:93f0:b967:5b47:245b:dc32]
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 18 Jul 2012 11:55:02 +0200
Message-ID: <CAG-2HqVOJ=+YxaVOy2NSXt76zW8edJ0uP7NcObHhESwSwFHcqw@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

[sorry for the messed up threading, I could not figure out how to make
gmail use in-relp-to]

> The point I'm slowly getting to is that I would actually love to have
> *distro* Kconfig-files, where the distribution would be able to say
> "These are the minimums I *require* to work". So we'd have a "Distro"
> submenu, where you could pick the distro(s) you use, and then pick
> which release, and we'd have something like

As someone working on one of the smaller distributions (Arch), I think
it would be even better if rather than having "distro" entries, we'd
have "application" entries. I.e., entries for applications that have
specific kernel requirements/suggestions (udev, systemd, upstart,
bootchart, pulseaudio, networkmanager, etc). If applications have soft
requirements, they could have sub-entries explaining the benefit of
enabling each.

In most cases, what a distro needs depends just on what applications
they ship, so you'd get the distro entries almost for free (fedora
selects systemd, udev, ...).

As was pointed out by someone else in this thread, it might easily
happen that applications change their kernel requirements without the
packagers noticing, or at least without the kernel packager being
told. If it had been possible for applications to ship drop-in Kconfig
files that they would install to a certain location, and the kernel
would simply pick them up, that would put the responsibility of
maintaining these things in the hands of the people who know the best
(the application developers).

Cheers,

Tom
