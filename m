Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2EGVe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:34:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63542 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2EGVey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:34:54 -0400
Date: Mon, 7 May 2012 14:34:49 -0700
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Warning in worker_enter_idle()
Message-ID: <20120507213449.GM19417@google.com>
References: <20120506153814.GA25681@linux.vnet.ibm.com>
 <20120507194042.GG19417@google.com>
 <20120507205516.GD21152@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507205516.GD21152@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 07, 2012 at 01:55:16PM -0700, Paul E. McKenney wrote:
> I was running rcutorture with CPU hotplug operations.  It has happened
> a couple of times on the .config that I attached, but never under any
> of the other 13 .configs that I run.

Ah, okay.  The invariant breaks when CPU detaches.  The WARN_ON()
probably just needs a condition to disable it if the gcwq is detached.
I'll look into it tomorrow.

Thanks.

-- 
tejun
