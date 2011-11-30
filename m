Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1K3GG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:06:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1K3GGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:06:24 -0500
Date: Tue, 29 Nov 2011 22:07:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20111129220728.b3351335.akpm@linux-foundation.org>
In-Reply-To: <20111130.004010.1075431174091251814.davem@davemloft.net>
References: <20111130155226.b571cfd7887f03f9e8e1285b@canb.auug.org.au>
	<20111130.004010.1075431174091251814.davem@davemloft.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 00:40:10 -0500 (EST) David Miller <davem@davemloft.net> wrote:

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 30 Nov 2011 15:52:26 +1100
> 
> > And many more similar.
> > 
> > Caused (or exposed) by commit 9222aa56c0ce
> > ("include/net/netprio_cgroup.h: various fixes") from the akpm tree.
> > 
> > I have reverted that commit for today.
> 
> Andrew, please submit networking bug fixes to the networking maintainers
> in order to avoid problems like this in the future.
> 
> Unlike other subsystems, I guarentee to handle it within 24 hours, often
> much faster.
> 

This is my attempt to address the issues I mentioned last week.  It is
still under development and doesn't work yet.  I thought it did.

I'm now trying to get my brain around what that code is doing with
Kconfig symbols and net_prio_subsys_id.  I'm suspecting it's all to
make cgroup-subsys-within-a-module appear to work.

afaict net_prio_subsys_id is an enum if CONFIG_NETPRIO_CGROUP=y and is
an `extern int' when CONFIG_NETPRIO_CGROUP=m.  It's unclear to me why
the extern int version or net_prio_subsys_id exists at all, really.

