Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2I0ERJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:17:09 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40092 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0ERG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:17:06 -0400
MIME-Version: 1.0
Date: Thu, 27 Sep 2012 14:17:05 +1000
Message-ID: <CAPM=9twE-xoeFgKGyRuF1mwn17XUhxvoLTgJU1UC3CaHnrwFNQ@mail.gmail.com>
Subject: debugfs file creation from a user process ioctl
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

we've been seeing an error with nouveau and I'm not sure if its new or
we just never spent time looking into it.

The basics are when a new drm client opens the device it gets a
channel assigned, we allocate the channel and a side effect of channel
allocation is we get a file in debugfs with some info on the channel.
However this fails as the process context we are in is non-root, and
the directory is 755.

I don't think I want to be modifiying fsuid, but is there another
practical way to do this, its not majorly urgent, Ben has indicated
he's probably ripping the channel debugfs code out but I was just
wondering for future reference.

Dave.
