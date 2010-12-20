Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0LTATU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 19:19:20 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33044 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0LTATS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=j4yKY79yjsBdaSsuffKReg3950QPD0BQtrG17xqskAvDsdtDkhwln8IqEsHnngbK+Z
         pb68veeovFq2To9kyiCDte2AZTJgdk0KkUYD7mhemjkB1Pgdd6URx8NV5GC64NISlAIa
         MK0+Lvl8FzaRBPHFt/qAfcslSoERXNApYGh7c=
Message-ID: <4D0EA0FE.4090104@garzik.org>
Date: Sun, 19 Dec 2010 19:19:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        adam radford <aradford@gmail.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
Subject: Re: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts
 disabled externally
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-8-git-send-email-nab@linux-iscsi.org> <20101219231114.GI1263@parisc-linux.org>
In-Reply-To: <20101219231114.GI1263@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 06:11 PM, Matthew Wilcox wrote:
> I'm not sure this is the right direction to go.  Now that Jeff's done
> the pushdown and put in the compatibility macros, I don't think it makes
> sense to do another partial transition on each driver.  Much better to
> take our time, analyse each driver thoroughly, and kill the DEF_SCSI_QCMD
> in each driver without introducing IRQ_DISABLE_SCSI_QCMD.


Agreed...   DEF_SCSI_QCMD was intended, as you note, to encourage a 
piecemeal, in-depth approach to cleaning up the rest of the drivers. 
Hopefully DEF_SCSI_QCMD removal means someone actually figured out [or 
already knew] the locking for a driver, and created the most appropriate 
patch, rather than another half-step.

	Jeff


