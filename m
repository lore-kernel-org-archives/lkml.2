Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656Ab2ILRCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:02:44 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46986 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760645Ab2ILRBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:01:55 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Namjae Jeon <linkinjeon@gmail.com>, fengguang.wu@intel.com,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: Re: [PATCH 1/2] writeback: add dirty_background_time per bdi variable
In-Reply-To: <1346083274-3510-1-git-send-email-linkinjeon@gmail.com>
References: <1346083274-3510-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Sep 2012 22:31:45 +0530
Message-ID: <87r4q72n0m.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12091217-9574-0000-0000-0000046259D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> This patch is based on suggestion by Wu Fengguang:
> https://lkml.org/lkml/2011/8/19/19
>
> kernel has mechanism to do writeback as per dirty_ratio and dirty_background
> ratio. It also maintains per task dirty rate limit to keep balance of
> dirty pages at any given instance by doing bdi bandwidth estimation.
>
> Kernel also has max_ratio/min_ratio tunables to specify percentage of writecache
> to control per bdi dirty limits and task throttling.
>
> However, there might be a usecase where user wants a writeback tuning
> parameter to flush dirty data at desired/tuned time interval especially
> at NFS server.
>
> dirty_background_time provides an interface where user can tune background
> writeback start time using /sys/block/sda/bdi/dirty_background_time
>
> dirty_background_time is used alongwith average bdi write bandwidth estimation
> to start background writeback.
>
> One of the use case to demonstrate the patch functionality can be
> on NFS setup:-
> We have a NFS setup with ethernet line of 100Mbps, while the USB
> disk is attached to server, which has a local speed of 25MBps. Server
> and client both are arm target boards.
>
> Now if we perform a write operation over NFS (client to server), as
> per the network speed, data can travel at max speed of 100Mbps. But
> if we check the default write speed of USB hdd over NFS it comes
> around to 8MB/sec, far below the speed of network.
>
> Reason being is as per the NFS logic, during write operation, initially
> pages are dirtied on NFS client side, then after reaching the dirty
> threshold/writeback limit (or in case of sync) data is actually sent
> to NFS server (so now again pages are dirtied on server side). This
> will be done in COMMIT call from client to server i.e if 100MB of data
> is dirtied and sent then it will take minimum 100MB/10Mbps ~ 8-9 seconds.
>

can't the bdi on nfs client side indicate that the commit need to be
send in smaller chunks ?. ie, we need the client to figure out that
the NFS srever is backed by a slow usb disk and accordingly send the
commit request ?


-aneesh

