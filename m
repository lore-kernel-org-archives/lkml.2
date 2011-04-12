Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1DLHpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:45:39 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:34218 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab1DLHph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:45:37 -0400
Subject: Re: [RFC-v3 2/3] qla2xxx: Enable 2xxx series LLD target mode
	support
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Madhu Iyengar <madhu.iyengar@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Ruediger Oertel <ro@suse.de>, Andy Grover <agrover@redhat.com>
In-Reply-To: <4DA34A52.6020409@vlnb.net>
References: <1301980307-14778-1-git-send-email-nab@linux-iscsi.org>
	 <1301980307-14778-3-git-send-email-nab@linux-iscsi.org>
	 <4DA34A52.6020409@vlnb.net>
Content-Type: text/plain
Date: Tue, 12 Apr 2011 00:38:04 -0700
Message-Id: <1302593884.25449.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 22:37 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 04/05/2011 09:11 AM wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch enables target mode support with the qla2xxx SCSI LLD using
> > qla_target.c logic introduced in commit f86d9fc734.  This includes:
> > 
> > *) Addition of target mode specific members to existing data
> > structures in qla_def.h and struct qla_hw_data->qla2x_tmpl using
> > qla_target.h:struct qla_target_template.
> > 
> > *) Addition of struct qla_target_template and direct calls into
> > qla_target.c logic w/ qla_tgt_* prefixed functions.
> > 
> > *) Addition of qla_iocb:qla2x00_req_pkt() for ring processing, and
> > qla2x00_issue_marker() for handling request/response queue processing
> > for target mode operation
> > 
> > *) Addition of various qla_tgt_mode_enabled() logic checks in
> > qla24xx_nvram_config(), qla2x00_initialize_adapter(), qla2x00_rff_id(),
> > qla2x00_abort_isp(), qla24xx_modify_vp_config(), and qla2x00_vp_abort_isp().
> > 
> > For the specific checks for qla_hw_data->qla2x_tmpl this includes:
> > 
> > *) control plane:
> > 
> > qla_init.c:qla2x00_rport_del() -> qla_tgt_fc_port_deleted()
> > qla_init.c:qla2x00_reg_remote_port() -> qla_tgt_fc_port_added()
> > qla_init.c:qla2x00_device_resync() -> qla2x00_mark_device_lost()
> > 
> > *) I/O path:
> > 
> > qla_isr.c:qla2x00_async_event() -> qla_tgt_async_event()
> > qla_isr.c:qla2x00_process_response_queue() -> qla_tgt_response_pkt_all_vps()
> > qla_isr.c:qla24xx_process_response_queue() -> qla_tgt_response_pkt_all_vps()
> 
> Most of this code was written by me and other SCST developers. How about
> to give proper credits to the original authors?
> 

Hello Vlad,

I intend to give proper fabric module credit where fabric module credit
is due  The original copyright from yourself + SCST developers is in
place in this patch, as well as my own copyright for the modern LLD
refactoring, forward-port and cleanups to work with mainline target
infrastructure.

I have no issues with including your's and other original author's names
for the pioneering work into the commit log for the next round of review
of PATCH #2, and am happy to make sure this is included for a future
squashed version of the series for a mainline commit.

--nab

