Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1KQSvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:51:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45435 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1KQSvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:51:37 -0500
MIME-Version: 1.0
In-Reply-To: <4EC472A1.6000407@xenotime.net>
References: <20111116133342.3eb15cac16f4c081dc6ed009@canb.auug.org.au>
	<4EC472A1.6000407@xenotime.net>
Date: Thu, 17 Nov 2011 19:51:35 +0100
X-Google-Sender-Auth: u__6Zv0PIm3jOT1psyl4tZTXyhM
Message-ID: <CAO+b5-q8doXbGBVkCD+jSjov8ermfVCgBB+WJUPXj=eVh1z87A@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 16 (infiniband: ib_srpt.c)
From: Bart Van Assche <bvanassche@acm.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux RDMA <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 3:34 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 11/15/2011 06:33 PM, Stephen Rothwell wrote:
>> Hi all,
>
>
> When CONFIG_BUG is not enabled:
>
> next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_cm_dreq_recv':
> next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c:2761:3: error: implicit declaration of function '__WARN'
>
>
> jbd2 has a similar issue (still unpatched).  One of the comments in that thread
> was that ext4 probably should use WARN_ON() instead of __WARN().
>
> Or (Arnd said):
> Hmm, my feeling is that we shouldn't do that either, and that jbd2 should
> be changed. If we want a function that does what __WARN() does today, we
> should probably make a conscious decision about what we want it to be called
> and not have it start with "__". <end Arnd>

Thanks for reporting this. The __WARN() statements in ib_srpt are
present in code paths that should never be reached. I'll post a patch
that addresses the build failure.

Bart.
