Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab0KOQCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:02:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54525 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab0KOQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:02:10 -0500
From: Andy Whitcroft <apw@canonical.com>
To: "David S. Miller\"" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 0/1] rtnetlink/netdevice include triggers userspace compiler errors
Date: Mon, 15 Nov 2010 16:01:58 +0000
Message-Id: <1289836919-19153-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have seen a number of reports of userspace applications (including
eglibc) which fail to compile when trying to use linux/rtnetlink.h.
It appears that a new helper function has necessitated the inclusion of
linux/netdevice.h which in turn causes a collision with userspace headers
from libc, with net/if.h.

It appears that this header is not required for the userspace exported
components of rtnetlink.h.  Following this email is a patch to pull this
include down in the the kernel specific section of this header.  It seems
to both fix this issue for userspace and still compiles correctly for
kernel use.

Against v2.6.37-rc1.

-apw

Andy Whitcroft (1):
  net: rtnetlink.h -- only include linux/netdevice.h when used by the
    kernel

 include/linux/rtnetlink.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

