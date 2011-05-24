Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1EXVcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:32:23 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36731 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab1EXVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:32:21 -0400
Subject: Re: [PATCH 5/6] target: Convert REPORT_LUNs to use int_to_scsilun
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>
In-Reply-To: <1305861554-29960-6-git-send-email-nab@linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
	 <1305861554-29960-6-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 13:02:57 -0400
Message-ID: <1306256577.10201.13.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 20:19 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts transport_core_report_lun_response() to use
> drivers/scsi/scsi_scan.c:int_to_scsilun instead of using the
> struct target_core_fabric_ops->pack_lun() fabric provided API vector.
> 
> It also removes the tfo->pack_lun check from target_fabric_tf_ops_check()
> and removes from struct target_core_fabric_ops->pack_lun() from
> target_core_fabric_ops.h, and the following mainline scsi-misc fabric
> modules:
> 
> *) tcm_loop: Drop tcm_loop_pack_lun() usage
> *) tcm_fc: Drop ft_pack_lun() usage
> 
> Reported-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

There's no way this or the following patch count as bug fixes.  They're
converging hand rolled functions and definitions (which is good, but not
a bug fix).

James


