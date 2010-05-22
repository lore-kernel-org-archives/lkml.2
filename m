Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab0EVUoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 16:44:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48828 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab0EVUo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 16:44:27 -0400
Date: Sat, 22 May 2010 21:44:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd
 and other processes
Message-ID: <20100522204426.GO31073@ZenIV.linux.org.uk>
References: <201005221535.38939.shawn.starr@rogers.com>
 <4BF83CBF.8080300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF83CBF.8080300@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 01:21:19PM -0700, walt wrote:
> On 05/22/2010 12:35 PM, Shawn Starr wrote:
> >Just built today's snapshot from linus's tree and have problems with udev
> >using 100% cpu and KDE processes also pegging cpus.
> >
> >This is with Fedora 13 + snapshot kernel from git.
> >
> >Anyone else noticing this?
> 
> Yes, just bisected it to this:
> 
> commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
> Author: Eric Paris <eparis@>
> Date:   Fri May 14 11:44:10 2010 -0400
> 
>     anon_inode: set S_IFREG on the anon_inode

Cute...  Frankly, I'd be fine with just reverting that one and teaching
selinux to STFU.  However, I wonder what specifically is getting polled.
Which anon_inode users?

Does anybody have strace handy?
