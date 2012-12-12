Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab2LLGN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:13:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27917 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2LLGN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:13:56 -0500
X-IronPort-AV: E=Sophos;i="4.84,264,1355068800"; 
   d="scan'208";a="6380970"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: [PATCH v12 0/8] pv event to notify host when the guest is panicked
Date: Wed, 12 Dec 2012 14:13:43 +0800
Message-Id: <cover.1355290850.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/12 14:13:05,
	Serialize complete at 2012/12/12 14:13:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements a new interface, kvm pv event, to notify host when
some events happen in guest. Right now there is one supported event: guest
panic.

changes from v11:

  - add a new patch 'save/load cpu runstate'
  - fix a bug of null-dereference when no -machine option is supplied
  - reserve RUN_STATE_GUEST_PANICKED during migration
  - add doc of enable_pv_event option
  - disable reboot-on-panic if pv_event is on

v11: http://lists.gnu.org/archive/html/qemu-devel/2012-10/msg04361.html

Hu Tao (7):
  save/load cpu runstate
  update kernel headers
  add a new runstate: RUN_STATE_GUEST_PANICKED
  add a new qevent: QEVENT_GUEST_PANICKED
  introduce a new qom device to deal with panicked event
  allower the user to disable pv event support
  pv event: add document to describe the usage

Wen Congyang (1):
  start vm after resetting it

 block.h                          |   2 +
 docs/pv-event.txt                |  17 ++++
 hw/kvm/Makefile.objs             |   2 +-
 hw/kvm/pv_event.c                | 197 +++++++++++++++++++++++++++++++++++++++
 hw/pc_piix.c                     |  11 +++
 kvm-stub.c                       |   4 +
 kvm.h                            |   2 +
 linux-headers/asm-x86/kvm_para.h |   1 +
 linux-headers/linux/kvm_para.h   |   6 ++
 migration.c                      |   7 +-
 monitor.c                        |   6 +-
 monitor.h                        |   1 +
 qapi-schema.json                 |   6 +-
 qemu-config.c                    |   4 +
 qemu-options.hx                  |   3 +-
 qmp.c                            |   5 +-
 savevm.c                         |   1 +
 sysemu.h                         |   2 +
 vl.c                             |  52 ++++++++++-
 19 files changed, 312 insertions(+), 17 deletions(-)
 create mode 100644 docs/pv-event.txt
 create mode 100644 hw/kvm/pv_event.c

-- 
1.8.0.1.240.ge8a1f5a

