Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2AFGFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:05:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40880 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2AFGFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:05:09 -0500
MIME-Version: 1.0
In-Reply-To: <20120104065454.155836791@sli10-conroe.sh.intel.com>
References: <20120104065337.230911609@sli10-conroe.sh.intel.com>
	<20120104065454.155836791@sli10-conroe.sh.intel.com>
Date: Fri, 6 Jan 2012 15:05:07 +0900
Message-ID: <CAKYAXd-z0toe1rCUvaYBEqvTSwbRtE_9iCZGuvwU4nJm0SP27A@mail.gmail.com>
Subject: Re: [RFC 2/3]block: FIOPS ioscheduler core
From: Namjae Jeon <linkinjeon@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, vgoyal@redhat.com,
        jmoyer@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ===================================================================
> --- linux.orig/block/Kconfig.iosched    2011-12-28 09:42:18.000000000 +0800
> +++ linux/block/Kconfig.iosched 2012-01-04 13:58:35.000000000 +0800
> @@ -43,6 +43,14 @@ config CFQ_GROUP_IOSCHED
>        ---help---
>          Enable group IO scheduling in CFQ.
>
> +config IOSCHED_FIOPS
> +       tristate "IOPS based I/O scheduler"
> +       default y
> +       ---help---
> +         This is an IOPS based I/O scheduler. It will try to distribute
> +          IOPS equally among all processes in the system. It's mainly for
> +          Flash based storage.
> +
>  choice
>        prompt "Default I/O scheduler"
>        default DEFAULT_CFQ
Hi.
Is below code needed ?
choice
        prompt "Default I/O scheduler"
        default DEFAULT_CFQ
        help
          Select the I/O scheduler which will be used by default for all
          block devices.

        config DEFAULT_DEADLINE
                bool "Deadline" if IOSCHED_DEADLINE=y

        config DEFAULT_CFQ
                bool "CFQ" if IOSCHED_CFQ=y

+        config DEFAULT_FIOPS
+                bool "FIOPS" if IOSCHED_FIOPS=y

        config DEFAULT_NOOP
                bool "No-op"

config DEFAULT_IOSCHED
        string
        default "deadline" if DEFAULT_DEADLINE
        default "cfq" if DEFAULT_CFQ
        default "noop" if DEFAULT_NOOP
+        default "fiops" if DEFAULT_FIOPS
