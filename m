Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab0EUGSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 02:18:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46467
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933282Ab0EUGRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 02:17:55 -0400
Date: Thu, 20 May 2010 23:18:03 -0700 (PDT)
Message-Id: <20100520.231803.168054302.davem@davemloft.net>
To: lwoodman@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: RFC: dirty_ratio back to 40%
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BF51B0A.1050901@redhat.com>
References: <4BF51B0A.1050901@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Woodman <lwoodman@redhat.com>
Date: Thu, 20 May 2010 07:20:42 -0400

> Increasing the dirty_ratio to 40% will regain the performance loss
> seen in several benchmarks.  Whats everyone think about this???

I've been making this change via sysctl on every single system I have,
and have been doing so for quite some time.

When doing a lot of GIT operations to a non-SSD disk the kernel simply
can't submit the writes early enough to prevent everything getting
backlogged, and then processes pile up being forced to sleep on I/O
for several seconds at a time.

I therefore totally support making this the default, but I know some
people will be against it :-)

Acked-by: David S. Miller <davem@davemloft.net>
