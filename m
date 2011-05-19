Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819Ab1ESVdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:33:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47130 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab1ESVdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JxS96Bx851TPhZioSdQ/ECB9FLjcgDmWBKUOuuXa8/8cMAzrJKti8BLoLCnnBaAoP3
         Y+RUU6iKRjBzdyAD+cU5hE4O8LppvTiPF1YUsCR87PvC0qtFg4QTJAMrcYFoCJXt7N7Q
         UXkPRYw7Z3guDZ1dGcv7XzjJQWos4cH/Eohyg=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: [PATCH 00/23] add register_chrdev_ids() to char_dev.c, API
Date: Thu, 19 May 2011 15:33:03 -0600
Message-Id: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

over on kernelnewbies, gregkh said:

     The chardev stuff is a mess, I keep meaning for years to clean it
     up.  Any proposals on a sane interface for this stuff is greatly
     appreciated.

this is a 1st step.

register_chrdev_ids() replaces and deprecates register_chrdev_region()
and alloc_chrdev_region() with a single function that works for both
dynamic and static major numbers.

Like alloc_chrdev_region(), 1st arg is a dev_t*, but its an in/out
parameter, and expects both major and minor to be preset, and thus the
separate minor arg is dropped.  If major == 0, a dynamic major is
reserved, saved into 1st arg, and thus available to caller afterwards.

[PATCH 01/23] add register_chrdev_ids() to char_dev.c, API
[PATCH 02/23] reimplement alloc_chrdev_region with
[PATCH 03/23] use register_chrdev_ids to replace
[PATCH 04/23] use register_chrdev_ids in drivers/tty/
[PATCH 05/23] use register_chrdev_ids in drivers/infiniband/
[PATCH 06/23] use register_chrdev_ids in drivers/media/
[PATCH 07/23] use register_chrdev_ids in drivers/s390/
[PATCH 08/23] use register_chrdev_ids in drivers/scsi/
[PATCH 09/23] use register_chrdev_ids in drivers/staging/

Ive held back the rest, no point in spamming.

