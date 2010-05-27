Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab0E0SmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:42:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab0E0Sl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:41:58 -0400
Message-ID: <4BFEBCEF.8010201@vlnb.net>
Date: Thu, 27 May 2010 22:41:51 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: James Bottomley <James.Bottomley@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Douglas Gilbert <dgilbert@interlog.com>,
       Joe Eykholt <jeykholt@cisco.com>,
       Richard Sharpe <realrichardsharpe@gmail.com>,
       James Smart <James.Smart@Emulex.Com>, Jeff Garzik <jeff@garzik.org>,
       Joel Becker <joel.becker@oracle.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC]: Mainline of TCM Core and TCM_Loop for v2.6.35
References: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/23Ae7fZ0xrZNPj/mZ1GRRVICh6phEgL/ZKz+
 yESJFThUcGHgwWOyd/uXK8Kgls+kj6O44IL6aB2as9FluZNQBf
 56P8eRbBSJZa4fOkBr54w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas A. Bellinger, on 05/20/2010 05:09 AM wrote:
> Greetings James and Co,
> 
> I would like to formally request the inclusion of TCM Core v4 codebase
> containing the fabric independent configfs infrastructure design and
> TCM_Loop SCSI LLD fabric module supporting multi-fabric I_T Nexus and
> Port emulation for SAS, FC and iSCSI into mainline for v2.6.35
> 
> The plan is to push TCM Core and the TCM_Loop LLD module for use with
> existing userspace applications into mainline first, and then focus on
> extending the upstream fabric libraries (libiscsi, libfc, libsas) for
> new and future TCM modules to support a common set of kernel-level
> target mode infrastructure for HW and SW fabric engines once the main
> target pieces are in place.
> 
> On the userspace fabric <-> kernel backstore side, the TCM_Loop fabric
> module is currently running with full SPC-3 PR and ALUA support using
> fabric-independent virtual SCSI target port emulation with the STGT
> iSCSI userspace fabric code and SG_IO backstores.  TCM_Loop is also
> being used with SG_IO for QEMU-KVM megasas HBA emulation into Linux and
> MSFT x86 guests and is able to run at sustained 10 Gb/sec throughput
> into KVM guest.
> 
> For the kernelspace fabric <-> userspace backstore side for v2.6.35, the
> plan is to extend the existing drivers/scsi/scsi_tgt_[lib,if].c direct
> mapped ring interface to the WIP kernel level TCM/STGT subsystem
> backstore plugin mentioned in previously on linux-scsi.  This will allow
> projects presenting a userspace block device to access existing TCM
> kernel level target module fabric drivers.

I've got 2 question and 1 note.

1. Are there any evidences that TCM has any value over STGT? So far, 
I've only read not supported words with once a reference to my effort on 
completely unrelated project.

2. Are there any users of this code using it in production to prove its 
usability and stability? I mean, used not by RisingTide and its 
customers, because on the RisingTide's web page it's clearly written 
that their target software "partially available as the open-source LIO 
Core target". So, all the RisingTide's experience isn't relevant for 
this code. As we can see Linux-iSCSI.org development mailing list 
(http://groups.google.com/group/linux-iscsi-target-dev?hl=en) has near 
zero activity.

The note is that the idea to use the STGT's scsi_tgt_[lib,if].c direct 
mapped ring interface to extend TCM in the user space and allow present 
STGT's user space devices to work with TCM is unpractical, because the 
STGT's interface and devices are built around SCSI target state machine 
and memory management in the user space, while TCM has them both in the 
kernel.

Vlad

