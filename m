Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab2JAROx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:14:53 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47042 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab2JAROu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:14:50 -0400
Date: Mon, 1 Oct 2012 12:10:03 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter.Huewe@infineon.com, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Message-ID: <20121001171003.GA1117@ennui.austin.ibm.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001161536.GC31620@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100117-1976-0000-0000-000011E6546D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:15:36AM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 01, 2012 at 09:17:28AM +0000, Peter.Huewe@infineon.com wrote:
> > Hi Jason,
> > 
> > > The TPM will respond to TPM_GET_CAP with TPM_ERR_INVALID_POSTINIT if
> > > TPM_STARTUP has not been issued. This will result in the TPM driver
> > > failing to load and no way to recover. Detect this and automatically
> > > issue TPM_STARTUP.
> > 
> > > This is for embedded applications where the kernel is the first thing
> > > to touch the TPM.
> > 
> > Thanks for working on this.
> > I also thought about this scenario quite often.
> > 
> > Shouldn't we then also add a TpmStartup(ST_STATE) in case of a resume?
> >  rc=GetCapability()
> >  if(rc==INVALID_POSTINIT)
> >  	tpm_transmit ("TPM_STARTUP(ST_STATE)")...
> 
> I'm not familiar enough with how the power management flow works with
> the TPM to do this. I don't think that can be the general case
> because:
> 
> 3. If stType = TPM_ST_STATE
>   a. If the TPM has no state to restore, the TPM MUST set the internal
>      state such that it returns TPM_FAILEDSELFTEST to all subsequent
>      commands.
> 
> So you need to know a save state exists in the TPM before attempting
> the command?

 Presumably we'd have called TPM_SaveState on suspend. It might be
possible to set a flag based on whether we needed to call startup at
init time that tells the driver to call save/restore state during
suspend/resume.

Kent

> Would you agree that CLEAR is appropriate for an initial driver
> attach on probe?
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

