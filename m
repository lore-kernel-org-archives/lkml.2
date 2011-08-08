Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1HHTW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:22:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:50038 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1HHTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:22:27 -0400
Subject: Re: drivers/target/target_core_transport.c breakage on i386
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: agrover@redhat.com, linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <20110808001055.GB2203@ZenIV.linux.org.uk>
References: <20110808001055.GB2203@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 08 Aug 2011 12:12:46 -0700
Message-Id: <1312830766.12502.12.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 01:10 +0100, Al Viro wrote:
> In commit ec98f7825c6eaa4a9afb0eb518826efc8a2ed4a2
> Author: Andy Grover <agrover@redhat.com>
> Date:   Wed Jul 20 19:28:46 2011 +0000
> 
>     target: Eliminate usage of struct se_mem
> 
> we got
> +       task_count = DIV_ROUND_UP(sectors, dev_max_sectors);
> and that's sector_t/sector_t.  64bit division on i386 is no-no in
> the kernel - it emits __udivdi3 call and it's not there.  Can
> sectors really reach 2^32 here?
> 

Hi Al,

Just a heads up that this was caught this before -rc1, and we ended up
adding DIV_ROUND_UP_ULL using do_div() for the 32-bit case here, and
another DIV_ROUND_UP_SECTOR_T macro that target_core_transport.c is now
using to address this for i386.

kernel.h: Add DIV_ROUND_UP_ULL and DIV_ROUND_UP_SECTOR_T macro usage
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=36a26c69b4c70396ef569c3452690fba0c1dec08

Thanks,

--nab


