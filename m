Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3AEJm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 04:42:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab3AEJmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 04:42:23 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V2 0/3] handle polling errors in vhost/vhost_net
Date: Sat,  5 Jan 2013 17:34:03 +0800
Message-Id: <1357378446-19656-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update version of last version to fix the handling of polling errors
in vhost/vhost_net.

Currently, vhost and vhost_net ignores errors of polling which can lead kernel
crashing for buggy/malicious userspace. Fix this by extending the idea of tx
polling state to all other vhost_polls and changing the state only when polling
succeed.

Jason Wang (3):
  vhost_net: correct error handling in vhost_net_set_backend()
  vhost: handle polling errors
  tuntap: don't add to waitqueue when POLLERR

 drivers/net/tun.c     |    5 +--
 drivers/vhost/net.c   |   89 ++++++++++++++++++++----------------------------
 drivers/vhost/vhost.c |   25 +++++++++++---
 drivers/vhost/vhost.h |   11 +++++-
 4 files changed, 68 insertions(+), 62 deletions(-)

