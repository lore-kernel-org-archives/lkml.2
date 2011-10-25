Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1JYKHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:07:45 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:60641 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1JYKHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:07:43 -0400
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>
In-Reply-To: <CA+55aFyBgZoaN2di1iE4fyMh0r1rECG3stgiqGtiGY4SY7nBmw@mail.gmail.com>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
	 <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
	 <20111025094232.GA17763@lst.de>
	 <CA+55aFyBgZoaN2di1iE4fyMh0r1rECG3stgiqGtiGY4SY7nBmw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 03:07:30 -0700
Message-ID: <1319537250.18871.23.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 11:45 +0200, Linus Torvalds wrote:
> On Tue, Oct 25, 2011 at 11:42 AM, Christoph Hellwig <hch@lst.de> wrote:
> > On Tue, Oct 25, 2011 at 11:29:39AM +0200, Linus Torvalds wrote:
> >> On Tue, Oct 25, 2011 at 11:00 AM, Nicholas A. Bellinger
> >> <nab@linux-iscsi.org> wrote:
> >> >
> >> > ?36 files changed, 937 insertions(+), 2068 deletions(-)
> >>
> >> Hmm. This is not what I get. It might be a git version issue or diff
> >> algorithm one - although that's actually pretty unusual. Do you do
> >> something odd/special?
> >
> > It's mostly me looking at the code and factoring code and removing
> > unneeded things from old versions.
> 
> No, I'm saying that the diffstat doesn't match what I get when I pull.
> 
> I get
> 
>  36 files changed, 955 insertions(+), 2086 deletions(-)
> 
> which is *close*, but not identical. I'm wondering where the numbers
> Nicholas has came from..
> 

Ok, just verified with git 1.7.2.3 from target-pending.git and the
numbers match up with your pull.   Here is the full diff-stat for
reference.  My apologies for the extra noise.

--nab

 drivers/target/Makefile                      |    1 -
 drivers/target/iscsi/iscsi_target.c          |   39 +-
 drivers/target/iscsi/iscsi_target_auth.c     |   34 +-
 drivers/target/iscsi/iscsi_target_core.h     |    4 +-
 drivers/target/iscsi/iscsi_target_erl2.c     |   49 +-
 drivers/target/iscsi/iscsi_target_tmr.c      |    6 +-
 drivers/target/iscsi/iscsi_target_util.c     |   20 +-
 drivers/target/iscsi/iscsi_target_util.h     |    1 +
 drivers/target/loopback/tcm_loop.c           |   18 +-
 drivers/target/target_core_alua.c            |   21 +-
 drivers/target/target_core_cdb.c             |   79 ++-
 drivers/target/target_core_configfs.c        |   16 +-
 drivers/target/target_core_device.c          |   70 +-
 drivers/target/target_core_fabric_configfs.c |    1 -
 drivers/target/target_core_file.c            |   56 +-
 drivers/target/target_core_file.h            |    4 +-
 drivers/target/target_core_iblock.c          |  274 ++----
 drivers/target/target_core_iblock.h          |    2 -
 drivers/target/target_core_pr.c              |    1 -
 drivers/target/target_core_pscsi.c           |  261 ++----
 drivers/target/target_core_pscsi.h           |    1 -
 drivers/target/target_core_rd.c              |   19 +-
 drivers/target/target_core_rd.h              |    2 -
 drivers/target/target_core_scdb.c            |  105 --
 drivers/target/target_core_scdb.h            |   10 -
 drivers/target/target_core_stat.c            |    1 -
 drivers/target/target_core_tmr.c             |  251 +++--
 drivers/target/target_core_transport.c       | 1513 ++++++++------------------
 drivers/target/target_core_ua.c              |    1 -
 drivers/target/tcm_fc/tfc_cmd.c              |   18 +-
 drivers/target/tcm_fc/tfc_conf.c             |   13 +-
 drivers/target/tcm_fc/tfc_io.c               |    1 -
 drivers/target/tcm_fc/tfc_sess.c             |    1 -
 include/target/target_core_base.h            |   71 +-
 include/target/target_core_tmr.h             |    2 +-
 include/target/target_core_transport.h       |   75 +-
 36 files changed, 955 insertions(+), 2086 deletions(-)
 delete mode 100644 drivers/target/target_core_scdb.c
 delete mode 100644 drivers/target/target_core_scdb.h



