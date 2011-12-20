Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1LTXKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:10:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44386 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1LTXKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:10:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 21 Dec 2011 00:10:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Carl Karsten <carl@personnelware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] firewire: do not expose globally unique IDs in the
 kernel log
Message-ID: <20111221001031.539ef397@stein>
In-Reply-To: <CADmzSSjfFgrAroh8jZfC-q0dNuDgsyoNcUfTik6gBx75zrngFw@mail.gmail.com>
References: <20111220213017.75ff380c@stein>
	<20111220213120.5e275f10@stein>
	<CADmzSSjfFgrAroh8jZfC-q0dNuDgsyoNcUfTik6gBx75zrngFw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20 Carl Karsten wrote:
> grumble.
> 
> I use those guids like so:
> 
> plug in dv cam, dmesg, cut guid to clipboard, run:
> dvgrab -guid (paste)

How about:

	#!/bin/sh
	guid=$(cat /sys/bus/firewire/devices/$1/guid)
	shift
	dvgrab -guid $guid "$@"

To be called as "dvgrab-wrapper fw3 [more dvgrab options]", with fw3 being
the device of your choice, e.g. the one that just scrolled by in syslog.

Or you run "grep . /sys/bus/firewire/devices/*/guid | sed s/\\/guid:/\\t/"
before dvgrab, and you get a list of GUIDs from which you can copy and
paste.

> It also kinda helps me keep track of what devices are misbehaving, but
> this alone isn't very important.
> 
> Any chance of making this configurable?

So far the configuration of the "new" firewire drivers were kept at an
essential minimum, and I am hesitant to add more baroque ones.  I would
rather drop this patch now that there was negative feedback, unless there
is going to be positive feedback as well.
-- 
Stefan Richter
-=====-==-== ==-- =-=--
http://arcgraph.de/sr/
