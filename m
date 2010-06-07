Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0FGI1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 04:27:25 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:26322 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756462Ab0FGI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 04:27:24 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: AY5eGlIVM1mjzDGYJDz6tlxPjBYW3OyR3WjH4Z_5Edfe0T4y44tveIDS.SNNwzt.eEzyL0i_88AIsNTyJkiP56qIiesjRrj6q3elGaVGo6Ll4.CgwWL3A6NFlrBvGPodVSPWen9g8pnmoCe0xVEuuUa0OpWb45s3sM6bY02KfGwxJFkuHM45gi8xbfb4jBQOO_zf63OdiU0PIJLp2UhRXeRey4Nh3e6JnECzKFbxH1_7lWos8XMrmBG0Tpbx6mEwWRhsOpWo0nA3G5n9TkW6OaSqH2Qnjs9TEDsHA3C_A4j1wpISPhXF3ldEcFYX42xrZSszoFvSyi5mRUyc6S3reKkP
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu,
       bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com
In-Reply-To: <20100607154432Y.fujita.tomonori@lab.ntt.co.jp>
References: <1275882615-5354-1-git-send-email-nab@linux-iscsi.org>
	 <20100607154432Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Mon, 07 Jun 2010 01:27:16 -0700
Message-Id: <1275899236.26888.40.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 15:45 +0900, FUJITA Tomonori wrote:
> On Sun,  6 Jun 2010 20:50:15 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greeting STGT folks,
> > 
> > This is the third round of patches for adding proper LUN passthrough support into STGT
> > using struct scsi_lu->cmd_perform() and struct scsi_lu->cmd_done() callers with existing
> > SG_IO and the new BSG v4 backstores.
> > 
> > Following Tomo-san's input, the changelog between v2 -> v3 is as follows:
> > 
> > 1) Add struct device_type_template sg_template for SG_IO and BSG in usr/bs_sg.c instead
> >    of making changes to usr/sbc.c
> > 
> > 2) Add struct backingstore_template->bs_passthrough member of type int for SG_IO and BSG.
> > 
> > 3) In usr/target.c:tgt_device_create() pass bst->bs_passthrough into device_type_lookup()
> >    and for passthrough case use the new device_type_passthrough() to locate
> >    struct device_type_template sg_template.
> > 
> > 4) Remove unnecessary post_cmd_done() from usr/target.c:__cmd_done_passthrough()
> > 
> > This patch series has been tested with STGT/iSCSI using 'sg'+'bsg' and 'rdwr' for non
> > passthrough mode backstores into TCM_Loop LLD emulated iSCSI target ports.
> > 
> > Best,
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org
> > 
> > Nicholas Bellinger (3):
> >   [tgt]: Add proper STGT LUN backstore passthrough support (rev 3)
> >   [tgt]: Add bs_sg struct device_type_template sg_template and struct
> >     backingstore_template->bs_init()
> >   [tgt]: Add BSG v4 backstore support to usr/bs_sg.c
> > 
> >  usr/bs_sg.c     |  247 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  usr/scsi_cmnd.h |    7 ++
> >  usr/target.c    |  113 +++++++++++++++++++++++---
> >  usr/tgtd.h      |   16 ++++
> >  4 files changed, 362 insertions(+), 21 deletions(-)
> 
> The first and second patches Look fine overall. I have some comments
> and wrote some cleanup patches.
> 
> I've put the first two patches with my cleanups:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/tgt.git pass
> 
> Can you confirm that it works for you? Then I can merge them into
> master.

The pass branch works fine using '-E sg -Y pt' for SG_IO backstore <->
fabric LUN assocation with TCM_Loop LLD Target Ports.  Thanks for
cleaning things up to use TYPE_PT btw, I should have asked about that
earlier. ;)

> 
> Let's leave bsg support alone and focus on the sg support for now.
> --

Ok, I just fixed some minor breakage and applied patch 3 on top of
tgt.git/pass in my local tree and everything appears to work with
'-E bsg -Y pt'.

Please let me know if you have any other comments on the BSG bits or if
you would like me to send along a updated patch 3 seperately.

Thanks Tomo!

--nab


