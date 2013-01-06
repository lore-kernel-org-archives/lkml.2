Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3AFH1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 02:27:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3AFH07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 02:26:59 -0500
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        davem@davemloft.net
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V3 0/2] handle polling errors
Date: Sun,  6 Jan 2013 15:18:36 +0800
Message-Id: <1357456718-3072-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update version of last version to fix the handling of polling errors
in vhost/vhost_net.

Currently, vhost and vhost_net ignore polling errors which can lead kernel
crashing when it tries to remove itself from waitqueue after the polling
failure. Fix this by checking the poll->wqh before the removing and report an
error when meet polling errors.

Changes from v2:
- check poll->wqh instead of the wrong assumption about POLLERR and waitqueue
- drop the whole tx polling state check since it was replaced by the wqh
  checking
- drop the buggy tuntap patch

Changes from v1:
- restore the state before the ioctl when vhost_init_used() fails
- log the error when meet polling errors in the data path
- don't put into waitqueue when tun_chr_poll() return POLLERR

Jason Wang (2):
  vhost_net: correct error handling in vhost_net_set_backend()
  vhost: handle polling errors

 drivers/vhost/net.c   |   88 +++++++++++++++++++-----------------------------
 drivers/vhost/vhost.c |   31 +++++++++++++----
 drivers/vhost/vhost.h |    2 +-
 3 files changed, 59 insertions(+), 62 deletions(-)

