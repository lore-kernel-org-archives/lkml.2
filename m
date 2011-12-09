Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1LIQ70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:59:26 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1LIQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:59:25 -0500
Subject: Re: workqueue_set_max_active(wq, 0)?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111209165702.GD12108@google.com> (sfid-20111209_175740_727764_F62FADDC)
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
	 <20111209165702.GD12108@google.com> (sfid-20111209_175740_727764_F62FADDC)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 17:59:23 +0100
Message-ID: <1323449963.3622.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

> > Before I dive in more deeply I figured I'd ask if you think what a good
> > way of doing this would be (and whether I'm completely insane) :-)
> 
> Hmmm... yeah, actually, that's what wq uses internally to implement
> freezable workqueues.  It sets max_active to 0 temporarily and waits
> for all in-flight works to finish.  On thaw, the original value is
> restored.

Right, it's a little more complicated though because it has to wait etc.

> Updating workqueue_set_max_active() to return the old value would be a
> nice API update which goes together, I think.

Yeah, that would probably be useful, in particular if one tries to
freeze a paused workqueue...

johannes

