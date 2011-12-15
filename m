Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab1LOGx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:53:59 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46476 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932261Ab1LOGx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:53:58 -0500
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20111215125818.f9ffb338c0085f2ba9908a42@canb.auug.org.au>
References: <20111215125818.f9ffb338c0085f2ba9908a42@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 10:53:52 +0400
Message-ID: <1323932032.3210.7.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 12:58 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/qla4xxx/ql4_os.c:2135:6: error: redefinition of 'qla4xxx_check_relogin_flash_ddb'
> drivers/scsi/qla4xxx/ql4_os.c:2081:6: note: previous definition of 'qla4xxx_check_relogin_flash_ddb' was here
> 
> Caused by a bad automatic merge when I merged the scsi tree today.  The
> patch "[SCSI] qla4xxx: fix flash/ddb support" appears in both the scsi
> and scsi-rc-fixes tree (as separate commits) and git has messed up the
> merge.  I fixed it up by using the version of this file from the scsi
> tree.

Erk sorry ... I blame tglx ... I had to rebase the rc-fixes tree to get
a cc stable on to one of his patches, but I need to rebase scsi-misc as
well since it's built on top of rc-fixes.  Should be fixed for the next
go around (which is where the duplicate came from).

James


