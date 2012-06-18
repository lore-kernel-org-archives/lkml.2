Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2FRBYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 21:24:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59592 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2FRBYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 21:24:06 -0400
Date: Sun, 17 Jun 2012 18:24:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc: james.smart@emulex.com, linux-kernel@vger.kernel.org
Subject: Re: Driver scsi/lpfc breaks build since 3.4.1
Message-ID: <20120618012401.GA13192@kroah.com>
References: <4FDE71A4.2090807@mni.thm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FDE71A4.2090807@mni.thm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 02:09:08AM +0200, Tobias Klausmann wrote:
> Hello there,
> since 3.4.1 the driver scsi/lpfc breaks my build for some unused variables:
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl’:
> drivers/scsi/lpfc/lpfc_scsi.c:1900:11: error: unused variable ‘rc’
> [-Werror=unused-variable]
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl_prot’:
> drivers/scsi/lpfc/lpfc_scsi.c:2037:11: error: unused variable ‘rc’
> [-Werror=unused-variable]
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl’:
> drivers/scsi/lpfc/lpfc_scsi.c:2256:11: error: unused variable ‘rc’
> [-Werror=unused-variable]
> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl_prot’:
> drivers/scsi/lpfc/lpfc_scsi.c:2386:11: error: unused variable ‘rc’
> [-Werror=unused-variable]
> cc1: all warnings being treated as errors
> 
> From the drivers makefile:
> ccflags-y += -Werror <- this causes the bad behavior.

As has been stated before, this ccflags setting is what needs to be
fixed, not trying to fix up the warnings here (although that is a good
goal overall.)

Also, this isn't how to submit a patch to the stable kernel tree, please
read Documentation/stable_kernel_rules.txt for how to properly do that.

thanks,

greg k-h
