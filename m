Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab2JDSCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:02:52 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50499 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2JDSCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:02:51 -0400
Date: Thu, 4 Oct 2012 12:02:47 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Peter.Huewe@infineon.com, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Issue TPM_STARTUP at driver load if
 the TPM has not been started
Message-ID: <20121004180247.GC2994@obsidianresearch.com>
References: <20120930233012.GH30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121001161536.GC31620@obsidianresearch.com>
 <20121001171003.GA1117@ennui.austin.ibm.com>
 <20121001173908.GA22342@obsidianresearch.com>
 <20121004174114.GA6520@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004174114.GA6520@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:41:15PM -0500, Kent Yoder wrote:

>   I'd rather see us just track the state and do the right thing
> here. If we don't get invalid postinit if we call tpm_startup during
> tpm_tis_init/tpm_tis_i2c_init, then set a flag we switch on here.

At least on my platform it is possible for tpm_tis_init to skip the
TPM_STARTUP path I added if kexec has been used, so it is not a
reliable indicator that the platform does/does not support the TPM.

Directly checking if the TPM has been started on resume seems fool
proof to me?

Jasson
