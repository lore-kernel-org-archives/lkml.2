Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0HDESM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:18:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:32986 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628Ab0HDESJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:18:09 -0400
Subject: Re: linux-next: build warning after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20100804131300.8570fe77.sfr@canb.auug.org.au>
References: <20100804131300.8570fe77.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 00:17:56 -0400
Message-ID: <1280895476.11045.323.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc linux-scsi added

On Wed, 2010-08-04 at 13:13 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/scsi/scsi_sysfs.c:384: warning: dereferencing 'void *' pointer
> 
> Introduced by commit db5bd1e0b505c54ff492172ce4abc245cf6cd639 ("[SCSI]
> convert to the new PM framework").  This build does not have
> CONFIG_PM_OPS set.

So this one looks to be a compiler error.  in the none CONFIG_PM_OPS
case, we have

scsi_priv.h:#define scsi_bus_pm_ops             (*NULL)

So &scsi_bus_pm_ops should be NULL (not a deref of null).

James


