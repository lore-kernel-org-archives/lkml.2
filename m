Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1ELW1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:27:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36636 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1ELW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:27:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (namespace tree related)
References: <20110512135113.93c1b671.sfr@canb.auug.org.au>
Date: Thu, 12 May 2011 15:27:27 -0700
In-Reply-To: <20110512135113.93c1b671.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Thu, 12 May 2011 13:51:13 +1000")
Message-ID: <m1zkmrlflc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/eBNVT7jgdVQ9p4h2v5ZqVmXcDk1XeFLI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
>
> net/built-in.o: In function `get_net_ns_by_fd':
> (.text+0x11976): undefined reference to `netns_operations'
> net/built-in.o: In function `get_net_ns_by_fd':
> (.text+0x1197a): undefined reference to `netns_operations'
>
> netns_operations is only available if CONFIG_NET_NS is set ...
>
> Caused by commit f063052947f7 ("net: Allow setting the network namespace
> by fd").
>
> I applied the patch below for today.

How embarrassing.  I should have caught this one myself.

I have applied your patch.  


At some point I need to see what the impact of removing the various
CONFIG_XXX_NS defines is and get rid of them.  Their original purpose
was only to let administrators avoid buggy code, but most of the
namespaces are well beyond where that now and it seems those
CONFIG_XXX_NS defines are just causing trouble.  But not for 2.6.40.

Eric
