Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab1GGI5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:57:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56416 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab1GGI5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:57:36 -0400
Date: Thu, 7 Jul 2011 12:55:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 2/2] taskstats: restrict access to user
Message-ID: <20110707085551.GA4718@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
 <20110629201718.GA11071@albatros>
 <20110702073625.GA3318@albatros>
 <CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
 <20110704174540.GA3321@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704174540.GA3321@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 21:45 +0400, Vasiliy Kulikov wrote:
> The already known danger is these io fields.

Two more things:

1) unblocking netlink socket on task exit is a rather useful help to win
different races.  E.g. if the vulnerable program has the code -

    wait(NULL);
    do_smth_racy();

- then the attacker's task listening for the taskstats event will be
effectively woken up just before the racy code.  It might greatly
increase the chanses to win the race => to exploit the bug.
(The same defect exists in inotify.)


2) taskstats gives the task information at the precisely specific moment
- task death.  So, the attacker shouldn't guess whether some event
occured or not.  The formula of gotten information is _exactly_ task
activity during the life.  On the contrary, getting the same information
from procfs files might result in some inaccuracy because of measuring
time inaccuracy (scheduler's variability, different disks' load, etc.).

Of cource, (2) makes sense only if some sensible information is still
available through taskstats.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
