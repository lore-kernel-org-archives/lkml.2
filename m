Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0JAUBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:01:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48101 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751625Ab0JAUBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:01:47 -0400
Date: Fri, 1 Oct 2010 15:01:43 -0500
From: Robin Holt <holt@sgi.com>
To: Davide Libenzi <davidel@xmailserver.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: max_user_watches overflows on 16TB system.
Message-ID: <20101001200143.GR14064@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following a boot of a 16TB system, we noticed that the max_user_watches
sysctl was negative.  Is there any downside to converting that to a
static long and handling the fallout from the change?  I believe that
fallout includes changing the definition of epoll_watches over to an
atomic_long_t as well.

Alternatively should we just limit max_user_watches to INT_MAX?

Thanks,
Robin Holt
