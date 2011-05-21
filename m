Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1EUPuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 11:50:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54877 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1EUPuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 11:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <4DD7C3A7.5010402@tilera.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
	<4DD6FB9E.2050604@tilera.com>
	<20110521032102.GD19907@suse.de>
	<201105211133.50238.arnd@arndb.de>
	<4DD7C3A7.5010402@tilera.com>
Date: Sat, 21 May 2011 08:50:43 -0700
Message-ID: <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
From: Eric Biederman <ebiederm@aristanetworks.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 6:52 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> Interesting!  I did in fact assume that most tools that read or write
> eeproms would tend to be "batch" tools, i.e. they would read or write
> whatever it was they wanted, then exit; the tool we have that modifies this
> EEPROM is written like that, for example.  It sounds like you're saying
> there are (or may be) tools that open the file descriptor and do writes to
> it, then don't exit or close the file descriptor, but expect the last write
> to have hit the device immediately.  It's fair to say that since my
> suggested API does defer the last sector's worth of writes until the app
> exits, it potentially violates that assumption, so it's a bad idea.

Plus the other gigantic difference that I have seen very few eeproms
that can hold a sectors worth of data.

My reading of this conversation is that you are confusing a configuration
eeprom with a nor flash boot device.  That is a bit like confusing a yellow
sticky not with the Encyclopedia Britannica.   They aren't at all the
same thing.

> On 5/21/2011 3:46 AM, Eric Biederman wrote:
>> What is wrong with an mtd driver?
>
> More backstory: we actually have an MTD driver for this device (in our
> local tree as drivers/mtd/devices/tile_srom.c) but we haven't yet tried to
> push it back to the community.  But it doesn't work for the most important
> purpose of this device, namely to serve as one of the possible boot streams
> at power-on.  For this, we have to control exactly what data is on what
> sector, which means a character (or sysfs) device.

How can an MTD driver not work to control exactly what data is on what
sector????  That is what MTD drivers do.

It sounds like you have a bug in either your userspace tools or your
implementation of your mtd driver.  That is definitely not a reason to
dump your device into a char device (mtdchar already exists).

> Sounds like the consensus is that a character driver is in fact the best
> option here.

I think the consensus is that your design is buggy.

Eric
