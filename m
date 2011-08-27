Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1H0Kfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 06:35:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1H0Kfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 06:35:39 -0400
Date: Sat, 27 Aug 2011 12:35:34 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>, menage@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110827103534.GK2632@htj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <201108252301.41778.rjw@sisk.pl>
 <20110825215444.GT2803@mtj.dyndns.org>
 <201108262309.38652.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108262309.38652.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Fri, Aug 26, 2011 at 11:09:38PM +0200, Rafael J. Wysocki wrote:
> > One thing I'm curious about is how many drivers do we have left which
> > depend on freezer as opposed to implementing proper quiescing
> > mechanism using PM hooks?  Are there still a lot left?
> 
> There is a number of drivers that use freezable workqueues and that's
> prefectly valid in my view.  Beyond that, may suspend/resume routines
> depend on the freezer to some extent, because they assume that user
> space won't talk to the driver while they are being run.
> 
> Do you mean any other kind of dependence?

I still feel a bit unsure about depending on freezer as escaping them
unintentionally seems a bit too easy (e.g. schedule_work() for delayed
processing) and as drivers need to implement responses to PM events
anyway, I think implementing the support explicitly has lesser chance
of causing obscure bugs which are difficult to reproduce.  Anyways,
something to discuss some other day, I guess.

Thanks.

-- 
tejun
