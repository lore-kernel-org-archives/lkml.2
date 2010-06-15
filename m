Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0FOLFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:05:25 -0400
Received: from poutre.nerim.net ([62.4.16.124]:58480 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab0FOLFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:05:23 -0400
Date: Tue, 15 Jun 2010 13:05:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <gregkh@suse.de>, mingo@elte.hu,
       tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 12/12] usb: use IRQ watching
Message-ID: <20100615130518.1a62210a@hyperion.delvare>
In-Reply-To: <AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
	<1276443098-20653-13-git-send-email-tj@kernel.org>
	<20100614214122.GA21064@suse.de>
	<4C16A48A.2070404@kernel.org>
	<4C16AAEE.5090204@kernel.org>
	<AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 12:30:00 +0200, Kay Sievers wrote:
> On Tue, Jun 15, 2010 at 00:19, Tejun Heo <tj@kernel.org> wrote:
> > Hmm... maybe what we can do is generating an uevent when an IRQ is
> > confirmed to be bad and then let udev notify the user.  That way we'll
> > probably have better chance of getting bug reports and users have
> > whiny but working system.
> 
> Not really, uevents are not picked up by anything that could report an
> error to userspace, they are just seen by udev. Also uevents are
> usually not the proper passing method. They are not meant to ever
> transport higher frequency events, or structured data. They cause to
> run the entire udev rule matching machine, and update symlinks and
> permissions with every event.
> 
> We will need some better error reporting facility. On Linux you don't
> even get notified when the kernel mounts your filesystem read-only
> because of an error. It will only end up in 'dmesg' as a pretty much
> undefined bunch of words. :)
> 
> We will need some generic error reporting facility, with structured
> data exported, and where userspace stuff can subscribe to.
> Uevents/udev can not really properly provide such infrastructure.
> Maybe that can be extended somehow, but using kobject_uevent() and
> trigger the usual udev rule engine is not what we are looking for, for
> sane error reporting.

Random idea of the day (I don't know anything about it all): let the
kernel connect to D-Bus and use it somehow?

-- 
Jean Delvare
