Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab2GDGWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:22:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44073 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab2GDGWg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 4 Jul 2012 02:22:36 -0400
Message-Id: <4FF3EF3A0200007800087520@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 04 Jul 2012 07:22:34 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <gregkh@linuxfoundation.org>, <kay@vrfy.org>
Cc: <yuanhan.liu@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmsg: properly handle concurrent non-blocking
 read() from /proc/kmsg
References: <1341339437.815.4.camel@mop>
In-Reply-To: <1341339437.815.4.camel@mop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Kay Sievers <kay@vrfy.org> 07/03/12 8:17 PM >>>
>From: Kay Sievers <kay@vrfy.org>
>Subject: kmsg: properly handle concurrent non-blocking read() from /proc/kmsg
>
>The /proc/kmsg read() interface is internally simply wired up to a sequence
>of syslog() syscalls, which might are racy between their checks and actions,
>regarding concurrency.
>
>In the (very uncommon) case of concurrent readers of /dev/kmsg, relying on
>usual O_NONBLOCK behavior, the recently introduced mutex might block an
>O_NONBLOCK reader in read(), when poll() returns for it, but another process
>has already read the data in the meantime. We've seen that while running
>artificial test setups and tools that "fight" about /proc/kmsg data.
>
>This restores the original /proc/kmsg behavior, where in case of concurrent
>read()s, poll() might wake up but the read() syscall will just return 0 to
>the caller, while another process has "stolen" the data.
>
>This is in the general case not the expected behavior, but it is the exact
>same one, that can easily be triggered with a 3.4 kernel, and some tools
>might just rely on it.
>
>The mutex is not needed, the original integrity issue which introduced it,
>is in the meantime covered by:
>"fill buffer with more than a single message for SYSLOG_ACTION_READ"
  >116e90b23f74d303e8d607c7a7d54f60f14ab9f2
>
>Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
>Cc: Jan Beulich <JBeulich@suse.com>
>Signed-off-by: Kay Sievers <kay@vrfy.org>

This being a revert of all but a single change of
4a77a5a06ec66ed05199b301e7c25f42f979afdc, which I had suggested to
be reverted anyway:

Acked-by: Jan Beulich <jbeulich@suse.com>


