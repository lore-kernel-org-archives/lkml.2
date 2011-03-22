Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1CVI4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:56:48 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37862 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1CVI4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:56:46 -0400
Date: Tue, 22 Mar 2011 14:26:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: mananth@in.ibm.com, benh@kernel.crashing.org, stable@kernel.org,
        anton@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [3/3] powerpc: rtas_flash needs to use rtas_data_buf
Message-ID: <20110322085638.GA14035@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110319181658.GD23832@linux.vnet.ibm.com> <20110321214501.GB9546@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110321214501.GB9546@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com> [2011-03-21 14:45:01]:

> On Sat, Mar 19, 2011 at 11:46:58PM +0530, Kamalesh Babulal wrote:
> >     powerpc: rtas_flash needs to use rtas_data_buf
> > 
> > 	Commit: bd2b64a12bf55bec0d1b949e3dca3f8863409646 upstream
> > 
> >     When trying to flash a machine via the update_flash command, Anton received the
> >     following error:
> > 
> >         Restarting system.
> >         FLASH: kernel bug...flash list header addr above 4GB
> > 
> >     The code in question has a comment that the flash list should be in
> >     the kernel data and therefore under 4GB:
> > 
> >             /* NOTE: the "first" block list is a global var with no data
> >              * blocks in the kernel data segment.  We do this because
> >              * we want to ensure this block_list addr is under 4GB.
> >              */
> > 
> >     Unfortunately the Kconfig option is marked tristate which means the variable
> >     may not be in the kernel data and could be above 4GB.
> > 
> >     Instead of relying on the data segment being below 4GB, use the static
> >     data buffer allocated by the kernel for use by rtas.  Since we don't
> >     use the header struct directly anymore, convert it to a simple pointer.
> > 
> >     Reported-By: Anton Blanchard <anton@samba.org>
> >     Signed-off-by: Milton Miller <miltonm@bga.com
> >     Tested-By: Anton Blanchard <anton@samba.org>
> >     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 	Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > ---
> > arch/powerpc/kernel/rtas_flash.c |   41 ++++++++++++++++++++-----------------
> >  1 files changed, 22 insertions(+), 19 deletions(-)
> 
> This diffstat differs from what the original commit had:
>  arch/powerpc/kernel/rtas_flash.c |   39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> So I went with the original commit, ok?
>

Sorry, my bad the mismatch was due to the indentation difference in the hunk

@@ -592,8 +589,8 @@ static void rtas_flash_firmware(int reboot_type)
    unsigned long rtas_block_list;
	 int i, status, update_token;
		 
-   if (rtas_firmware_flash_list.next == NULL)
-       return;     /* nothing to do */
+   if (rtas_firmware_flash_list == NULL)
+       return; /* nothing to do */
		  
will make sure, it does not happens again.

> Why are you diverging from the original?
> 
> thanks,
> 
> greg k-h
			
			Kamalesh
