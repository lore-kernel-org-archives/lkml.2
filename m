Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1DOWqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:46:12 -0400
Received: from tex.lwn.net ([70.33.254.29]:33302 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab1DOWqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:46:10 -0400
Date: Fri, 15 Apr 2011 16:46:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Tony Ibbs <tibs@tonyibbs.co.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Subject: Re: [PATCH] extra/1 Allow setting the maximum KBUS message size
Message-ID: <20110415164608.489d82bf@bike.lwn.net>
In-Reply-To: <32934D05-E7A7-4A2C-92EF-96A0580F2234@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
	<20110322133640.5d5c88e4@bike.lwn.net>
	<DBA665CD-BE12-4DC8-9B3F-4170BED789BD@tonyibbs.co.uk>
	<32934D05-E7A7-4A2C-92EF-96A0580F2234@tonyibbs.co.uk>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011 22:34:53 +0100
Tony Ibbs <tibs@tonyibbs.co.uk> wrote:

> This patch provides mechanisms for setting an absolute maximum message
> size at compile time, and a per-device maximum at runtime.

It seems like a good step in the right direction.  Do you really need to
add a bunch more configuration options, though?  It seems like a
reasonable default and a way to change it (sysfs file, maybe) might be
better.  Is there a way to cap the total memory used by the kbus subsystem?

The kzalloc() fixes seem like a good idea too, BUT:  I honestly think that
the item at the top of your list, if you want to merge this code, must be
to get the user-space API more widely reviewed and accepted.  It could, I
think, be a big sticking point, and it's something you want to try to
address sooner rather than later.

That means getting more people to look at the patch, which could be hard.
The problem is that, if you wait, they'll only squeal when the code is
close to going in, and you could find yourself set back a long way.  A
good first step might be to CC Andrew Morton on your next posting.

Thanks,

jon
