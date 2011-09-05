Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab1IEEEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 00:04:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab1IEEEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 00:04:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCHSET cgroup] extend threadgroup locking
Date: Mon, 5 Sep 2011 06:05:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
In-Reply-To: <1315159280-25032-1-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109050605.57360.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, September 04, 2011, Tejun Heo wrote:
> Hello,
> 
> cgroup currently only blocks new threads from joining the target
> threadgroup during migration, and on-going migration could race
> against exec and exit leading to interesting problems - the symmetry
> between various attach methods, task exiting during method execution,
> ->exit() racing against attach methods, migrating task switching basic
> properties during exec and so on.
> 
> This patchset extends threadgroup locking such that it covers all
> operations which can alter the threadgroup - fork, exit and exec, and
> update cgroup to take advantage of it.  rwsem read ops are added to
> exit path but exec is excluded by grabbing the existing
> cred_guard_mutex from threadgroup locking helper.
> 
> This makes threadgroup locking complete and resolves cgroup issues
> stemming from the target taskset being unstable.
> 
> This patchset is on top of the current pm-freezer + "freezer: fixes &
> simplifications" patchset and contains the following four patches.
> Patch list and diffstat follow.

OK

I'm assuming that there will be a branch for me to pull from when
kernel.org starts to work again, right?

Rafael
