Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab1JTK0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:26:20 -0400
Received: from mx.kernel.net.pl ([217.73.31.3]:54554 "EHLO an2.kernel.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750751Ab1JTK0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:26:19 -0400
From: Witold Krecicki <wpk@culm.net>
To: Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 0/6] cgroup: add isolation_root flag, poor man's namespaces for cgroups
Date: Thu, 20 Oct 2011 12:25:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.6.2; x86_64; ; )
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Matt Helsley <matthltc@us.ibm.com>
References: <1317382585-12172-1-git-send-email-wpk@culm.net> <CALdu-PDCxS49_GBBUQUskotKb_46O31YM8Tx+cniGfBa5X169g@mail.gmail.com>
In-Reply-To: <CALdu-PDCxS49_GBBUQUskotKb_46O31YM8Tx+cniGfBa5X169g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110201225.59627.wpk@culm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia czwartek, 20 października 2011 o 12:11:54 Paul Menage napisał(a):
> After talking with Eric Biederman at LPC about the virtualizability of
> containers, I was wondering whether we could go even further, and say
> that a hierarchy (in the sense of a tree of cgroups with a bound set
> of subsystems) could be broken at the point of an isolation root. The
> container could then construct its own hierarchies with potentially
> different combinations of subsystems.
I tried to make it as simple as possible - and this approach (looking at patch 
length) seemed to be the simplest (we really don't care about 'other' cgroups 
that might appear). Other approaches would probably require major rewrites of 
cgroups code.

> > I'm really not sure if the 'mount' part (patch 5) is done correctly,
> > please review carefully.
> 
> It looks simple, I agree, and as though it *ought* to work. My first
> worry with this was that if the parent system unmount the hierarchy,
> and all the tasks in the child container died (so its namespace was
> cleaned up), what would keep the root or the parent-created hierarchy
> alive? But I think that since the super-block also has a reference on
> the root dentry itself, it should be OK.
I've tested it and 'it works' so no problem there :)
I'm currently testing this setup with several containers launched under 
modified LXC (creating 'container_name' cgroup, then 'container_name/rootfs', 
then setting them both to desired values and putting init in 
'container_name/rootfs') - no problems so far.

-- 
Witold Krecicki


