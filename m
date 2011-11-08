Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1KHJ2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:28:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33837 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1KHJ2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:28:31 -0500
Subject: Re: [patch 1/3] sched: use jump labels to reduce overhead when
 bandwidth control is inactive
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Date: Tue, 08 Nov 2011 10:28:25 +0100
References: <20111108042632.977080206@google.com>
	 <20111108042736.560831357@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320744505.2244.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 10:26 +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 20:26 -0800, Paul Turner wrote:
> > +static void account_cfs_bandwidth_used(int enabled, int was_enabled)
> > +{
> > +       /* only need to count groups transitioning between enabled/!enabled */
> > +       if (enabled && !was_enabled)
> > +               jump_label_inc(&__cfs_bandwidth_used);
> > +       else if (!enabled && was_enabled)
> > +               jump_label_dec(&__cfs_bandwidth_used);
> > +} 
> 
> Can't you use jump_label_enabled(&__cfs_bandwidth_used) to was_enabled ?

n/m I'm not awake yet..
