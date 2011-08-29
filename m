Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1H2HRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:17:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38791 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458Ab1H2HRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:17:38 -0400
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>
In-Reply-To: <20110829120902.f95a92022c2d9170defdc083@canb.auug.org.au>
References: <20110829120902.f95a92022c2d9170defdc083@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 00:17:36 -0700
Message-ID: <1314602256.5038.1.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 12:09 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/qla2xxx/qla_nx.c: In function 'qla82xx_md_alloc':
> drivers/scsi/qla2xxx/qla_nx.c:4815:2: error: implicit declaration of function 'vmalloc'
> drivers/scsi/qla2xxx/qla_nx.c:4815:14: warning: assignment makes pointer from integer without a cast
> drivers/scsi/qla2xxx/qla_nx.c: In function 'qla82xx_md_free':
> drivers/scsi/qla2xxx/qla_nx.c:4845:3: error: implicit declaration of function 'vfree'
> 
> Caused by commit b60bb5832c00 ("[SCSI] qla2xxx: Add support for ISP82xx
> to capture dump (minidump) on failure").  Missing include of
> linux/vmalloc.h.  See Rule 1 in Documentation/SubmitChecklist.
> 
> I have used the scsi tree from next-20110826 for today.

Thanks for finding the problem.  I updated the commit with a simple fix
and re-pushed.

James


