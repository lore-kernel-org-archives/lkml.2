Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1CUQdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:33:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:53458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1CUQdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:33:39 -0400
Subject: Re: [build failure] Re: [GIT PULL] First round of SCSI updates for
 2.6.38 merge window
From: James Bottomley <James.Bottomley@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110321122111.GA17237@elte.hu>
References: <1300392635.17266.5.camel@mulgrave.site>
	 <20110321122111.GA17237@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 11:33:31 -0500
Message-ID: <1300725211.10634.20.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 13:21 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > This represents the usual round of driver updates (fcoe, lpfc,
> qla2xxx, > zfcp, bnx2i, mpt2sas, megaraid_sas, iscsi, cxgbi and hpsa)
> plus one new > driver (bnx2fc) and as a bonus we move libsas from the
> old libata eh to > the new one paving the way for junking the old one
> (once we can get ipr > converted).
> 
> The new bnx2fc driver does not build with module support disabled:
> 
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:17: error: dereferencing
> pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815:28:
> error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:17: error: dereferencing
> pointer to incomplete type  drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1878:28:
> error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)
> 
> and this build breakage has been reported to you two weeks ago:
> 
>  http://lkml.org/lkml/2011/3/2/468

The actual fix is here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=e81460b20107ae83a7541d12b14114ea731a86fc

it just took time to secure agreement on this.  The ultimate fixes to
FCoE will be in the next merge window.

James


