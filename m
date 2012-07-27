Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2G0OaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:30:21 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42171 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2G0OaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:30:19 -0400
Date: Fri, 27 Jul 2012 09:29:21 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Morris <jmorris@namei.org>, Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [GIT PULL] New TPM driver and features
Message-ID: <20120727142921.GA28347@linux.vnet.ibm.com>
References: <20120726143101.GA24237@linux.vnet.ibm.com>
 <5011BAB1.6060300@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5011BAB1.6060300@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072714-7408-0000-0000-0000072299ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 26, 2012 at 02:46:25PM -0700, H. Peter Anvin wrote:
> On 07/26/2012 07:31 AM, Kent Yoder wrote:
> >       hw_random: add support for the TPM chip as a hardware RNG source
> 
> Could you clarify this?  rngd (the user of /dev/hw_random) already
> has support for the TPM... is this fundamentally different (e.g. can
> it coexist with tcsd being in use at the same time)?

  These can coexist at the same time since /dev/tpm0 is only opened once
from user-space (from tcsd) and this hwrng driver comes in through the
kernel. There would be some amount of contention with the tpm, but its
not likely to be noticable - grabbing rng data doesn't require any state
in the tpm, like an auth session or key loading.

  Since the rngd support for the tpm requires trousers, this patch will
be useful in places where you don't want to have to deploy the full TSS,
like embedded and early boot.

Kent

> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

