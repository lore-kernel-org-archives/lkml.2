Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2GEWGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:06:49 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39923 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab2GEWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:06:47 -0400
Date: Thu, 5 Jul 2012 22:07:49 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Dilip Daya <dilip.daya@hp.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Network namespace and bonding WARNING at fs/proc/generic.c
 remove_proc_entry
Message-ID: <20120705220749.GA11255@mail.hallyn.com>
References: <1340900320.3441.88.camel@pro6455b.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340900320.3441.88.camel@pro6455b.example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dilip Daya (dilip.daya@hp.com):
> Hi,
> 
> I'd discussed the following with Serge Hallyn.
> 
> => Environment based on 3.2.18 / x86_64 kernel.
> => WARNING: at fs/proc/generic.c:808 remove_proc_entry+0xdb/0x21f()
> => WARNING: at fs/proc/generic.c:849 remove_proc_entry+0x208/0x21f()

Hi,

thanks much for sending this.  I'm still getting this error on
3.5.0-2-generic (today's ubuntu quantal kernel)

> network namespace and bonding
> -----------------------------
> 
> * Migrate two phy nics from host to netns (netns0).
>   - ip link set ethX netns netns0
> 
> * In host environment:
>   - load bonding module, /sbin/modprobe -v bonding mode=1 miimon=100
>   - /sys/class/net/bond0 exists.
>   - /proc/net/bonding/bond0 exists.
>   - /sys/class/net/bonding_masters has bond0.
> 
> * Migrate bond0 to netns (netns0):
>   - ip link set bond0 netns netns0.
> 
> * Within netns (netns0):
>   - /sys/class/net/bonding_masters is empty.
>   - /sys/class/net/bond0 exist.
>   - configure bond0 and ifenslave with two phy nics.
>   - /proc/net/bonding/bond0 does not exist within netns0, but does
>     exist in the host environment.
>   - /sys/class/net/bonding_masters is empty.

mine is not empty, fwiw.  However

>   - ping to remote end of bond0 works.
> 
> * Within netns (netns0), flushing ethX and bondY:
>   - down bond0 and its phy nic interfaces:
>   - ip link set ... down
>   - ip addr flush dev [bond0 | eth#]
>   - deleting bond0, /sbin/ip link del dev bond0

Yup I still get a remove_proc_entry WARNING at fs/proc/generic.c:808,
which is the warning when (!de)

-serge
