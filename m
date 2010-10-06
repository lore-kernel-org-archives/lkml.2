Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401Ab0JFChH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:37:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:39821 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373Ab0JFChF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:37:05 -0400
Date: Wed, 6 Oct 2010 11:36:38 +0900
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, hch@lst.de,
        hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk,
        bharrosh@panasas.com
Subject: Re: [RFC v2 06/21] tcm: Add fabric and subsystem transport engine
 core
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1285195763-11535-1-git-send-email-nab@linux-iscsi.org>
References: <1285195763-11535-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20101006113150S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 Oct 2010 11:36:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 15:49:23 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> The patch adds core generic target engine functionality including processing of struct se_cmd
> generation of N struct se_task, control CDB emulation, sense data, memory allocation, and
> and mapping from fabric module allocated memory using linked list struct scatterlist
> style memory based on the limitiations of the underlying TCM HBA and Device backstores.
> 
> The TCM layer sits is above Linux/SCSI, Linux/BLOCK and Linux/VFS subsystems, and
> communicates with these subsystems (and local RAMDISK plugins) using an API of function
> pointers in se_subsystem_api_t.  It provides processing capabilties and emulation for SCSI
> logic and CDBs in a generic manner to storage object LUNs provided from Linux storage
> subsystems backend storage devices.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_scdb.c      |  158 +
>  drivers/target/target_core_scdb.h      |   15 +
>  drivers/target/target_core_transport.c | 8860 ++++++++++++++++++++++++++++++++
>  include/target/target_core_transport.h |  570 ++
>  4 files changed, 9603 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/target_core_scdb.c
>  create mode 100644 drivers/target/target_core_scdb.h
>  create mode 100644 drivers/target/target_core_transport.c
>  create mode 100644 include/target/target_core_transport.h

Can a driver cleanly overwrite cmd->transport_emulate_cdb? ibmvscsi
target driver needs to the specific responses for INQUIRY and
REPORT_LUNS.

I guess that the driver can ignore the response buffer from tcm and
create the own but it would be nice if the driver can do cleanly.
