Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2H0UHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:07:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35364 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2H0UH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:07:28 -0400
Date: Mon, 27 Aug 2012 13:07:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] workqueue: static idle_rebind
Message-ID: <20120827200725.GC14812@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
 <1346090307-3020-8-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346090307-3020-8-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Aug 28, 2012 at 01:58:27AM +0800, Lai Jiangshan wrote:
> rebind_workers() is protected by cpu_hotplug lock,
> so struct idle_rebind is also proteced by it.
> 
> And we can use a compile time allocated idle_rebind instead
> of allocating it from the stack. it makes code clean.

I don't know.  While it seems correct, depending on outer locking
makes things more fragile and the dependency is implicit.  I'd rather
keep it separate.

Thanks.

-- 
tejun
