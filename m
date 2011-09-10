Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1IJArc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:47:32 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:55646 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1IJArb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:47:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1315615650!16021855!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: question: attribute 'require_context'
Date: Fri, 9 Sep 2011 17:47:18 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109091747.18525.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm trying to do an allyesconfig build of the kernel on an old debian box
with gcc version, gcc (Debian 4.3.2-1.1) 4.3.2. Everything goes fine until
the DRBD device driver gets compiled. At that point I get a bunch of
error messages like this:

drivers/block/drbd/drbd_int.h:974:39 error: attribute 'require_context': unknown attribute

It looks like this is due to the following:

#ifdef __CHECKER__
# define __protected_by(x)       __attribute__((require_context(x,1,999,"rdwr")))
# define __protected_read_by(x)  __attribute__((require_context(x,1,999,"read")))
# define __protected_write_by(x) __attribute__((require_context(x,1,999,"write")))
# define __must_hold(x)       __attribute__((context(x,1,1), require_context(x,1,999,"call")))
#else
# define __protected_by(x)
# define __protected_read_by(x)
# define __protected_write_by(x)
# define __must_hold(x)
#endif

Is the require_context attribute something found in a later version of gcc?

Thanks,
Hartley
