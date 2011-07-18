Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1GRROi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:14:38 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:49358 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753733Ab1GRROh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:14:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AqnITorQ9cF56DmsLprAkD3EB4ztvoUtld27jTH/N9j7c1diMlx7jIw4NHd5X1wA6i0fUbyoAQ1G0WnMhaayS0HpvXtXmjULwnKYLIbsJGuDzzT3aNwRhl2NT2d7qBHL;
Date: Mon, 18 Jul 2011 10:14:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pekka Enberg <penberg@kernel.org>, Amerigo Wang <amwang@redhat.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
Message-Id: <20110718101435.14c38ae7.rdunlap@xenotime.net>
In-Reply-To: <20110718170950.GD8006@one.firstfloor.org>
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>
	<CAOJsxLHuqvVEKg84jmRW_yfLic9ytB8GzeAE4YWauxSWryHGzA@mail.gmail.com>
	<20110718170950.GD8006@one.firstfloor.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011 19:09:50 +0200 Andi Kleen wrote:

> On Mon, Jul 18, 2011 at 03:14:18PM +0300, Pekka Enberg wrote:
> > On Mon, Jul 18, 2011 at 2:18 PM, Amerigo Wang <amwang@redhat.com> wrote:
> > > On ppc, we got this build error with randconfig:
> > >
> > > drivers/built-in.o:(.toc1+0xf90): undefined reference to `vmstat_text': 1 errors in 1 logs
> > >
> > > This is due to that it enabled CONFIG_NUMA but not CONFIG_SYSFS.
> > >
> > > And the user-space tool numactl depends on sysfs files too.
> > > So, I think it is very reasonable to make CONFIG_NUMA depend on CONFIG_SYSFS.
> > 
> > Is it? CONFIG_NUMA is useful even without userspace numactl tool, no?
> 
> Yes it is. No direct dependency.
> 
> I would rather fix it in ppc.

This isn't a ppc-only error.  It happens when CONFIG_PROC_FS is not enabled
(or is it CONFIG_SYSFS?).

I reported it for linux-next of 20110526:

when CONFIG_PROC_FS is not enabled:

drivers/built-in.o: In function `node_read_vmstat':
node.c:(.text+0x56ffa): undefined reference to `vmstat_text'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
