Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab1FIEn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 00:43:57 -0400
Received: from science.horizon.com ([71.41.210.146]:31887 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750698Ab1FIEnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 00:43:55 -0400
Date: 9 Jun 2011 00:43:54 -0400
Message-ID: <20110609044354.1171.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: eric.dumazet@gmail.com, luto@mit.edu
Subject: Re: Change in functionality of futex() system call.
Cc: david@rgmadvisors.com, dvhart@linux.intel.com, kyle@moffetthome.net,
        linux-kernel@vger.kernel.org, linux@horizon.com
In-Reply-To: <1307591659.3980.37.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can not prevent DOS on a machine if you allow a process to RO map
> your critical files (where you put futexes), because you allow this
> process to interfere with critical cache lines bouncing between cpus.
> 
> Really, please forget about this crazy idea of allowing foreigners to
> _read_ or memory _map_ your files. Don't do it.

Hold on.  There's a significant difference between making a system
run slowly (there are a hundred ways to achieve that, starting with
the classic fork bomb), and a permanent hard lockup caused by losing
a FUTEX_WAIT.

Among other things, you can notice a DoS after a while and kill it.
Things should then return to normal.

There may well be a reason to share a file containing futexes read-only.

Just for example, consider a circular buffer that a few (trusted)
processes can write to, but many (less trusted) can read.  Obviously,
being able to sleep on the head pointer is useful.

We are already dealing with one problem caused by a too-narrow idea of
how futexes would be used.  Let's not add another "nobody would ever
want to do that!" unnecessarily.
