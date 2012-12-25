Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2LYVyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 16:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab2LYVye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 16:54:34 -0500
Date: Tue, 25 Dec 2012 19:54:20 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v12 0/8] pv event to notify host when the
 guest is panicked
Message-ID: <20121225215420.GB6222@amt.cnet>
References: <cover.1355290850.git.hutao@cn.fujitsu.com>
 <20121220075359.GF7141@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220075359.GF7141@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 03:53:59PM +0800, Hu Tao wrote:
> Hi,
> 
> Any comments?

Did you verify possibilities listed at 
https://lkml.org/lkml/2012/11/20/653 ?

If so, a summary in the patchset would be helpful.

> On Wed, Dec 12, 2012 at 02:13:43PM +0800, Hu Tao wrote:
> > This series implements a new interface, kvm pv event, to notify host when
> > some events happen in guest. Right now there is one supported event: guest
> > panic.
> > 
> > changes from v11:
> > 
> >   - add a new patch 'save/load cpu runstate'
> >   - fix a bug of null-dereference when no -machine option is supplied
> >   - reserve RUN_STATE_GUEST_PANICKED during migration
> >   - add doc of enable_pv_event option
> >   - disable reboot-on-panic if pv_event is on
> > 
> > v11: http://lists.gnu.org/archive/html/qemu-devel/2012-10/msg04361.html
> > 
> > Hu Tao (7):
> >   save/load cpu runstate
> >   update kernel headers
> >   add a new runstate: RUN_STATE_GUEST_PANICKED
> >   add a new qevent: QEVENT_GUEST_PANICKED
> >   introduce a new qom device to deal with panicked event
> >   allower the user to disable pv event support
> >   pv event: add document to describe the usage
> > 
> > Wen Congyang (1):
> >   start vm after resetting it
> > 
> >  block.h                          |   2 +
> >  docs/pv-event.txt                |  17 ++++
> >  hw/kvm/Makefile.objs             |   2 +-
> >  hw/kvm/pv_event.c                | 197 +++++++++++++++++++++++++++++++++++++++
> >  hw/pc_piix.c                     |  11 +++
> >  kvm-stub.c                       |   4 +
> >  kvm.h                            |   2 +
> >  linux-headers/asm-x86/kvm_para.h |   1 +
> >  linux-headers/linux/kvm_para.h   |   6 ++
> >  migration.c                      |   7 +-
> >  monitor.c                        |   6 +-
> >  monitor.h                        |   1 +
> >  qapi-schema.json                 |   6 +-
> >  qemu-config.c                    |   4 +
> >  qemu-options.hx                  |   3 +-
> >  qmp.c                            |   5 +-
> >  savevm.c                         |   1 +
> >  sysemu.h                         |   2 +
> >  vl.c                             |  52 ++++++++++-
> >  19 files changed, 312 insertions(+), 17 deletions(-)
> >  create mode 100644 docs/pv-event.txt
> >  create mode 100644 hw/kvm/pv_event.c
> > 
> > -- 
> > 1.8.0.1.240.ge8a1f5a
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
