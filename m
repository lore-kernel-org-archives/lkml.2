Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2GTPsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 11:48:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39732 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2GTPsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 11:48:39 -0400
Message-ID: <1342799311.2583.7.camel@twins>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Date: Fri, 20 Jul 2012 17:48:31 +0200
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 10:12 -0700, Tejun Heo wrote:
> While this makes rebinding somewhat more complicated, as it has to be
> able to rebind idle workers too, it allows overall hotplug path to be
> much simpler.  

I really don't see the point of re-binding.. at that point you've well
and proper violated any per-cpu expectation, so why not complete running
the works on the disassociated thing and let new works accrue on the
per-cpu things again?
