Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1CJXWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:22:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976Ab1CJXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:22:13 -0500
Date: Thu, 10 Mar 2011 15:22:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/1] sysfs: add more info to the oops dump
Message-Id: <20110310152201.bb621c3f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1103110012060.2787@localhost6.localdomain6>
References: <20110310212746.GA3361@suse.de>
	<1299796027-3343-1-git-send-email-ext-phil.2.carmody@nokia.com>
	<1299796027-3343-2-git-send-email-ext-phil.2.carmody@nokia.com>
	<20110310143806.7542e929.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1103102354530.2787@localhost6.localdomain6>
	<20110310230621.GH7975@esdhcp04044.research.nokia.com>
	<alpine.LFD.2.00.1103110012060.2787@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 00:13:58 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> > > It's more of an distraction than anything which is relevant to 99.999%
> > > of the problems we have to deal with.
> > 
> > As I indicated before, I've previously thought that too, but thought I
> > could 'fix' it by adding to it when I hit the once-in-three-years case.
> 
> The interesting question is:
> 
>  How did that info help and was it really the ultimate reason why you
>  found the underlying bug ?

What happens with sysfs is that if a subsystem's handler is buggy, that
tends to cause a crash within sysfs core code.  You get a stack trace
which contains only VFS and sysfs functions - there is no symbol in the
trace which permits you to identify the offending subsystem.
