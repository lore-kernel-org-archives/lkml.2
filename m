Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0ENMjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 08:39:21 -0400
Received: from ozlabs.org ([203.10.76.45]:34104 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0ENMjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 08:39:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Milton Miller <miltonm@bga.com>
Subject: Re: cpumask: fix compat getaffinity
Date: Fri, 14 May 2010 22:09:13 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org, anton@samba.org
References: <201005112013.56392.arnd@arndb.de> <20100511031354.GA9327@kroah.com> <1273653045_3386@mail4.comsite.net>
In-Reply-To: <1273653045_3386@mail4.comsite.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005142209.14473.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 06:00:45 pm Milton Miller wrote:
> 
> At least for parsing, we need to allocate and parse NR_CPUS until
> all places like arch/powerpc/platforms/pseries/xics.c that compare a
> user-supplied mask to CPUMASK_ALL are eliminated.

Good point.  Anton will want to fix those anyway for CONFIG_CPUMASK_OFFSTACK,
too, but that's the reason the parsing uses nr_cpumask_bits.

> > Would it make sense to use my initial patch for -stable, which reverts
> > the ABI back to before the change that caused the problem, but apply
> > the correct fix (changing the ABI throughout) for future releases?
> 
> This would definitly be the conservative fix.

Instead of changing back to NR_CPUS which will break libnuma for
CPUMASK_OFFSTACK, how about changing it to nr_cpumask_bits and having an
explicit comment above it:

	/* libnuma assumes we match scnprintf for /sys/.../node/node*/cpumap */

Thanks,
Rusty.
