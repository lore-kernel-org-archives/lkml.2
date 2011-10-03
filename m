Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1JCOSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:18:39 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56779 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab1JCOSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:18:30 -0400
Date: Mon, 3 Oct 2011 10:18:23 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Andreas Dilger <aedilger@gmail.com>, Jeff liu <jeff.liu@oracle.com>,
        Dave Young <hidave.darkstar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [BUG] copy file result with zero
Message-ID: <20111003141823.GA6684@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, Jeff liu <jeff.liu@oracle.com>,
	Dave Young <hidave.darkstar@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com>
 <20111001143900.GH28234@thunk.org>
 <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com>
 <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com>
 <89E75765-AC24-4EF4-9547-6EE7A1A38B5A@dilger.ca>
 <CAGBYx2ZwCQDis-M0-qbdpBgbq34BR-OStMrcCK_+4u20CemXzg@mail.gmail.com>
 <alpine.LFD.2.00.1110031500430.4447@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1110031500430.4447@dhcp-27-109.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:11:30PM +0200, Lukas Czerner wrote:
> 
> Oops, you're right. I think that the best solution would be to revert
> the commit
> 
> c03f8aa9abdd517477c2021ea1251939b4da49e6
> ext4: use FIEMAP_EXTENT_LAST flag for last extent in fiemap
> 
> and then fix the original problem with your delayed extent tree
> solution, where we can easily check not only for next allocated extent,
> but also for next delayed extent to see if the current one is last or
> not.
> ...
>
> I do not know how "ready" are your patches..Is it possible to wait for
> them to be ready and fix it in your patch set ? That means, revert the
> mentioned commit and reimplement fiemap with delayed extent tree.

Sigh, yeah, we need to fix this to avoid the hang in xfstests #252 but
users losing data even if the coreutils release was only out there for
13 days is bad juju.

I'm working on reviewing the kernel patch backlog this week, and I'll
give this series one priority.

Thanks to Yongqiang and Lukas for looking into this!

							- Ted
