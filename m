Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0DALjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:39:47 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44863 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab0DALjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:39:39 -0400
Message-ID: <4BB485ED.80806@s5r6.in-berlin.de>
Date: Thu, 01 Apr 2010 13:39:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <b6fcc0a1003292338yafeb3d3k37fb3fa79af5340c@mail.gmail.com> <20100330070733.GC22419@nowhere> <201003301233.40461.arnd@arndb.de> <20100331172208.GB5163@nowhere>
In-Reply-To: <20100331172208.GB5163@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Mar 30, 2010 at 11:33:40AM +0100, Arnd Bergmann wrote:
>> I believe we can actually remove ioctl from file_operations. The patch I did
>> to convert all users to ".unlocked_ioctl = default_ioctl," should really catch
>> all cases, and I think we can enforce this by renaming fops->ioctl to locked_ioctl
>> or old_ioctl to make sure we didn't miss any, and then mandate that this one
>> is only used when unlocked_ioctl is set to default_ioctl.
> 
> 
> I just looked at the patch in question and noted that the changelog
> is pretty high, but how could it be else.
> Actually it's not that large, but highly spread:
> 
[Documentation/ arch/, drivers/, drivers/, and more drivers/, fs/,
include/, lib/, net/, sound/, virt/]
>  157 files changed, 372 insertions(+), 80 deletions(-)
> 
> 
> I wonder if we should actually just turn all these into unlocked_ioctl
> directly. And then bring a warn on ioctl, and finally schedule the removal
> of this callback.

A side note:  A considerable portion of this particular commit in Arnd's
git actually does not deal with .ioctl->.unlocked_ioctl at all, but
purely with .llseek.  Many(?) of these changes deal with .ioctl and
.llseek together.  (Arnd also says so in the last paragraph of his
changelog.)

IOW there are less .ioctl implementations left than one could think from
a look at the diffstat.
-- 
Stefan Richter
-=====-==-=- -=-- ----=
http://arcgraph.de/sr/
