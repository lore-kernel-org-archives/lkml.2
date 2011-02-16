Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1BPP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:59:46 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:25703 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752256Ab1BPP7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:59:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: kUTDlScVM1nUb48p2f9Ry21_SqMPYqpCCrtzkGt2oGW7OI9
 TQJf6VjcNWLkBcbiVS01P7e833wEixad9KX0mknBbBQjxpMrSsf8ZuNcwwZY
 At8f01uM7g_n8h8xDQouRDeqrXVAgib8BBUrf1rWqTpJIV1Gghi2Sn7wOi0t
 mQgnqyN4u3TIAF8VviRvDECdivO6TbskJbmoztVFa972NkFy2rfHEZi2C62z
 Yw9dqv_SY_sUsWX.EDqeTuMoUO5VYtQcSGY_RrQHLNtqltbfhejYaXApkA0_
 KTi94N6F9aCuzch1W4PfYM7F_WmkEgIKaVHJHPtM4.nBWC9o-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 16 Feb 2011 09:59:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: eric.dumazet@gmail.com
cc: Peter Kruse <pk@q-leap.com>, linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <4D5BC16A.2090205@q-leap.com>
Message-ID: <alpine.DEB.2.00.1102160956250.27814@router.home>
References: <4D53FE43.8030106@q-leap.com> <alpine.DEB.2.00.1102141046170.26158@router.home> <4D5A2EDB.8060603@q-leap.com> <alpine.DEB.2.00.1102151040560.10511@router.home> <4D5BC16A.2090205@q-leap.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1102160956252.27814@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, Peter Kruse wrote:

> > How many buffers are configured at the various levels for the device that
> > is receiving messages? I guess that may be a bit on the high side?
>
> hm, I'm not sure if I know what you want mean or want me to do.

NICs typically can be configured via ethtool for various queue sizes. Also
ifconfig can do some queue config. The ip tool too etc. Maybe Eric can
have a look at this. Looks like its an sk_clone from an interrupt context
that is causing the trouble.

> > The call traces are sufficient but the traces vanished when I hit reply.
> > Include them inline next time. It would be good to have the log starting
> > at the last system boot. There is some information cut off that I would to
> > see.
>
> Ok, I attach the gzipped kern.log.

We still do not have the messages from bootup. I can only see the OOM
messages itself not how the kernel booted up.

> > A significant amount of memory has been allocated to reclaimable slabs.
> > I guess these are the socket buffers?
> >
> > Feb 10 11:59:49 beosrv1-t kernel: [1968911.211777] Node 0 Normal
> > free:965164kB min:917952kB low:1147440kB high:1376928kB
> > active_anon:2742680kB inactive_anon:293184kB active_file:4801512kB
> > inactive_file:11129708kB unevictable:0kB isolated(anon):0kB
> > isolated(file):0kB present:21719040kB mlocked:0kB dirty:600kB
> > writeback:0kB mapped:26356kB shmem:4896kB slab_reclaimable:1780208kB
> > <-----!!
> > slab_unreclaimable:199576kB kernel_stack:1576kB pagetables:22956kB
> > unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
> > all_unreclaimable? no
> >
> > Could you try to reduce the number of network buffers?
>
> which parameter?

Ethtool, ifconfig and then there are various parameters in
/proc/sys/net/ipv4.
