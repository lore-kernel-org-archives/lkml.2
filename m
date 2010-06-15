Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0FOTbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:31:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033Ab0FOTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:31:07 -0400
Date: Tue, 15 Jun 2010 12:31:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dave.bueso@gmail.com
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uniform cdrom: fix mutex unlocking in
 /proc/sys/dev/cdrom/info file
Message-Id: <20100615123101.5b9addff.akpm@linux-foundation.org>
In-Reply-To: <1276627254.4666.0.camel@cowboy>
References: <1276102610.5572.32.camel@cowboy>
	<20100614123417.444a82c3.akpm@linux-foundation.org>
	<1276627254.4666.0.camel@cowboy>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 14:40:54 -0400
Davidlohr Bueso <dave.bueso@gmail.com> wrote:

> Regarding cdrom_sysctl_info(), I have noticed in several netbooks
> (haven't
> looked in other machines with no cdrom drive) that the
> /proc/sys/dev/cdrom/info file shows no values for the listed entries,
> ie:
> 
> CD-ROM information, Id: cdrom.c 3.20 2003/12/17
> 
> drive name:
> drive speed:
> drive # of slots:
> Can close tray:
> Can open tray:
> ...
> 
> Now, is this expected behavior? If not, should it be changed to
> something
> more descriptive? Perhaps it would affect user space applications that
> read
> the file?

It works for me.

Does your kernel build have CONFIG_SYSCTL=n?  If so, then all that code
is disabled.  That seems a bit bogus to me and perhaps we should enable
at least some of that code by CONFIG_PROCFS instead.

