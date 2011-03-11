Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1CKSbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:31:55 -0500
Received: from mx2.compro.net ([12.186.155.4]:42390 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1CKSby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:31:54 -0500
X-IronPort-AV: E=Sophos;i="4.62,304,1297054800"; 
   d="scan'208";a="6396164"
Message-ID: <4D7A6A99.5070304@compro.net>
Date: Fri, 11 Mar 2011 13:31:53 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kernel git bisect question
References: <4D793414.4090206@compro.net> <20110310215438.GE12521@home.goodmis.org>
In-Reply-To: <20110310215438.GE12521@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 04:54 PM, Steven Rostedt wrote:
> On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
>> Between git bisect [good | bad ]s should I always "make clean" or can I
>> count on the build system to take care of everything properly?
> 

I'm trying to bisect between 2.6.35 and 2.6.36. What have I done wrong?
Here is exactly what I've done. Why after my second "git bisect bad" do
I get a Makefile for 2.6.35-rc1 and then after the fourth I get a Makefile
for 2.6.34??
 

harley:/usr/src # git clone git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
Initialized empty Git repository in /usr/src/linux-2.6-allstable/.git/
remote: Counting objects: 1971777, done.
remote: Compressing objects: 100% (332768/332768), done.
remote: Total 1971777 (delta 1640306), reused 1952128 (delta 1621734)
Receiving objects: 100% (1971777/1971777), 402.59 MiB | 2.15 MiB/s, done.
Resolving deltas: 100% (1640306/1640306), done.

harley:/usr/src # cd linux-2.6-allstable
harley:/usr/src/linux-2.6-allstable # git bisect start
harley:/usr/src/linux-2.6-allstable # git bisect bad v2.6.36
harley:/usr/src/linux-2.6-allstable # git bisect good v2.6.35
Bisecting: 5103 revisions left to test after this (roughly 12 steps)
[78417334b5cb6e1f915b8fdcc4fce3f1a1b4420c] Merge branch 'bkl/core' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing


harley:/usr/src/linux-2.6-allstable # git bisect bad
Bisecting: 2414 revisions left to test after this (roughly 11 steps)
[6ba74014c1ab0e37af7de6f64b4eccbbae3cb9e7] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6


harley:/usr/src/linux-2.6-allstable # git bisect bad       (Why did this one give me a 2.6.35-rc1 Makefile)
Bisecting: 1366 revisions left to test after this (roughly 10 steps)
[b7753c8cd51dce67a0b152efb456a21ff1cc241b] cfg80211: fix dev <-> wiphy typo


harley:/usr/src/linux-2.6-allstable # git bisect bad       (Still a 2.6.35-rc1 Makefile)
Bisecting: 643 revisions left to test after this (roughly 9 steps)
[ef2519b1dd3994074e3e438d67f2d91d07c3a5a8] netxen: fail when try to setup unsupported features


harley:/usr/src/linux-2.6-allstable # git bisect bad       (Still a 2.6.35-rc1 Makefile)
Bisecting: 319 revisions left to test after this (roughly 8 steps)
[14599f1e341ee219abdd15f4eee5872d6f2d29f1] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6


harley:/usr/src/linux-2.6-allstable # git bisect bad       (Why did this one give me a 2.6.34 Makefile)
Bisecting: 161 revisions left to test after this (roughly 7 steps)
[86cc652dfe57f365533cf2e64e08ff37a510d42e] iwlwifi: remove debug frame dumping


Thanks again
Mark
