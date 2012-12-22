Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab2LVJri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 04:47:38 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39231 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2LVJrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 04:47:36 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC] spidev.c: add sysfs attributes for SPI configuration
To: Federico Vaga <federico.vaga@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1440955.3UsNh3CGzX@number-5>
References: <1353777608-24934-1-git-send-email-federico.vaga@gmail.com> <20121219150925.8262E3E0AD7@localhost> <1440955.3UsNh3CGzX@number-5>
Date: Sat, 22 Dec 2012 09:47:25 +0000
Message-Id: <20121222094725.797F03E03CE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 16:30:36 +0100, Federico Vaga <federico.vaga@gmail.com> wrote:
> On Wednesday 19 December 2012 15:09:25 Grant Likely wrote:
> > Not a good idea. sysfs is not a good place for operational
> > interfaces. Please use the spi character devices for direct
> > manipulation of the SPI configuration.
> 
> Hello,
> 
> Can you explain why it is not a good idea? I do not understand; what 
> is the advantage of ioctl through char device? Or what it the issue 
> with sysfs?
> 
> Thank you very much

I'm cautious about adding operational interfaces to sysfs because it can
be quite difficult to get the locking right. To begin with it splits up
a single interface into multiple files, any of which can be held open by
a process. Then there is the question of ordering of operations when
there are multiple users. For instance, if there were two users, each of
which using different transfer parameters, a sysfs interface doesn't
provide any mechanism to group setting up the device with the transfer.

These are lessons learned the hard way with the gpio sysfs abi. I don't
want to get caught in the same trap for spi.

g.
