Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2CIPnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:43:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53894 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2CIPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:43:52 -0500
From: Johan Hovold <jhovold@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: "David S. Miller" <davem@davemloft.net>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>,
        Greg KH <gregkh@linuxfoundation.org>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/3] bluetooth: bug fixes for 3.3
Date: Fri,  9 Mar 2012 16:43:23 +0100
Message-Id: <1331307806-21761-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This is a revised series which also contains a minimal fix to the memory leak
discovered by David Hermann upon which the first NULL-pointer-dereference fix
also depends.

These patches need to get to Linus ASAP as the problems are present in 3.3-rc6
as well as earlier kernels and thus should be backported to the stable trees as
well.

Thanks,
Johan


Johan Hovold (3):
  bluetooth: hci_ldisc: fix memory leak on tty_close
  bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
  bluetooth: hci_core: fix NULL-pointer dereference at unregister

 drivers/bluetooth/hci_ldisc.c |    4 ++--
 include/net/bluetooth/hci.h   |    2 ++
 net/bluetooth/hci_core.c      |    7 +++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

-- 
1.7.8.4

