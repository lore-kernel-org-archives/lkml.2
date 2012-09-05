Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab2IEUER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:04:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35112 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2IEUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:04:16 -0400
Date: Wed, 5 Sep 2012 13:04:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11 V5] workqueue: unbind/rebind without manager_mutex
Message-ID: <20120905200411.GD13737@google.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
 <1346841475-4422-11-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346841475-4422-11-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Sep 05, 2012 at 06:37:47PM +0800, Lai Jiangshan wrote:
> gcwq_unbind_fn() unbind manager by ->manager pointer.
> 
> rebinding-manger, unbinding/rebinding newly created worker are done by
> other place. so we don't need manager_mutex any more.
> 
> Also change the comment of @bind accordingly.

Please don't scatter small prep patches like this.  Each piece in
isolation doesn't make much sense to me and the patch descriptions
don't help much.  Please collect the prep patches and explain in more
detail.

In general, I'm not sure about this approach.  I'd really like the
hotplug logic to be contained in hotplug logic proper as much as
possible.  This scatters around hotplug handling to usual code paths
and seems too invasive for 3.6-fixes.

Also, can you please talk to me before going ahead and sending me
completely new 10 patch series every other day?  You're taking
disproportionate amount of my time and I can't continue to do this.
Please discuss with me or at least explain the high-level approach in
the head message in detail.  Going through the patch series to figure
out high-level design which is constantly flipping is rather
inefficient and unfortunately your patch descriptions aren't too
helpful.  :(

Thanks.

-- 
tejun
