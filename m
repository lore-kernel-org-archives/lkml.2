Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0LTGLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 01:11:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57450 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab0LTGLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 01:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=e+BND+0iFVyQ/YcyUNo0M0ymNmIBZpJQVkJ/IdW9Ri6P1XCjQwHmHLikLP2stFcvuu
         iBQ5zm3zZZJMBUrFLpI9tq9pW93CfKuWYPmntTNdj5sA6SiXFFfK4i1DmKmGCRTeUUxg
         0Uz4URFhbaBFNwuYiFIPCMW/ys85wCJ4Xsx4I=
Date: Mon, 20 Dec 2010 09:10:41 +0300
From: Dan Carpenter <error27@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [smatch] sched_fair: check after dereference
Message-ID: <20101220061041.GA8512@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

In linux-next e33078baa4 "sched: Fix update_cfs_load() synchronization"
introduced a dereference before the check for NULL.  I don't know the
code well enough to say if it's a bug or if the check can be removed.

kernel/sched_fair.c +728 update_cfs_load(6)
	warn: variable dereferenced before check 'cfs_rq'

   722  static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
   723  {
   724          u64 period = sysctl_sched_shares_window;
   725          u64 now, delta;
   726          unsigned long load = cfs_rq->load.weight;
                                     ^^^^^^^^^^^^^^^^^^^
   727
   728          if (!cfs_rq)
                     ^^^^^^
   729                  return;

Can you take a look?

regards,
dan carpenter

