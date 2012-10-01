Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2JAQPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:15:39 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56794 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab2JAQPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:15:38 -0400
Date: Mon, 1 Oct 2012 10:15:36 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter.Huewe@infineon.com
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Message-ID: <20121001161536.GC31620@obsidianresearch.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 09:17:28AM +0000, Peter.Huewe@infineon.com wrote:
> Hi Jason,
> 
> > The TPM will respond to TPM_GET_CAP with TPM_ERR_INVALID_POSTINIT if
> > TPM_STARTUP has not been issued. This will result in the TPM driver
> > failing to load and no way to recover. Detect this and automatically
> > issue TPM_STARTUP.
> 
> > This is for embedded applications where the kernel is the first thing
> > to touch the TPM.
> 
> Thanks for working on this.
> I also thought about this scenario quite often.
> 
> Shouldn't we then also add a TpmStartup(ST_STATE) in case of a resume?
>  rc=GetCapability()
>  if(rc==INVALID_POSTINIT)
>  	tpm_transmit ("TPM_STARTUP(ST_STATE)")...

I'm not familiar enough with how the power management flow works with
the TPM to do this. I don't think that can be the general case
because:

3. If stType = TPM_ST_STATE
  a. If the TPM has no state to restore, the TPM MUST set the internal
     state such that it returns TPM_FAILEDSELFTEST to all subsequent
     commands.

So you need to know a save state exists in the TPM before attempting
the command?

Would you agree that CLEAR is appropriate for an initial driver
attach on probe?

Jason
