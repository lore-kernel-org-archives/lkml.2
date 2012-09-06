Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab2IFRBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:01:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56813 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324Ab2IFRA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:00:59 -0400
Date: Thu, 6 Sep 2012 10:00:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11 V5] workqueue: unbind/rebind without manager_mutex
Message-ID: <20120906170054.GF29092@google.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
 <1346841475-4422-11-git-send-email-laijs@cn.fujitsu.com>
 <20120905200411.GD13737@google.com>
 <50487EA5.3060900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50487EA5.3060900@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Sep 06, 2012 at 06:44:53PM +0800, Lai Jiangshan wrote:
> On 09/06/2012 04:04 AM, Tejun Heo wrote:
> > Please don't scatter small prep patches like this.  Each piece in
> > isolation doesn't make much sense to me and the patch descriptions
> > don't help much.  Please collect the prep patches and explain in more
> > detail.
> 
> There are 4 different tasks. unbind/rebind manager/newbie
> 
> 1 task for 1 patch. if I collect them into one patch, it will be hard
> to explain which code do which task.

Not really.  Just list what each part does in the commit log and
explain how they're gonna be used by the following patch.

> > In general, I'm not sure about this approach.  I'd really like the
> > hotplug logic to be contained in hotplug logic proper as much as
> > possible.  This scatters around hotplug handling to usual code paths
> > and seems too invasive for 3.6-fixes.
> 
> I don't expect to fix it in 3.6. no approach is simple.

I think I can come up with something fairly simple.  Will post soon.

> > Also, can you please talk to me before going ahead and sending me
> > completely new 10 patch series every other day?  You're taking
> > disproportionate amount of my time and I can't continue to do this.
> > Please discuss with me or at least explain the high-level approach in
> > the head message in detail.  Going through the patch series to figure
> > out high-level design which is constantly flipping is rather
> > inefficient and unfortunately your patch descriptions aren't too
> > helpful.  :(
> 
> I'm not good in English, so I prefer to attach code when I show my idea.
> (and the code can prove the idea). I admit that my changelog and comments
> are always bad.

English isn't my first language either and I struggled with it for
quite a while too and it's perfectly okay to write non-perfect
sentences, but please do keep trying to express your ideas rather than
just throwing patches with one line description.  I'd be happy to
update the patch description and comments as necessary but no matter
how imperfect trying to communicate high level ideas in plain text
helps a lot.

* People might not understand fully but they would understand a lot of
  it.

* You'll have think one more time about it while trying to explain and
  justify all the changes in the patch.  It tends to make the code a
  lot better.

* Good patch descriptions and comments are often very important
  especially if one wants to make high-level restructuring changes
  like you're trying to.  It might be difficult right now but it won't
  get better without trying, right?

Thanks!

-- 
tejun
