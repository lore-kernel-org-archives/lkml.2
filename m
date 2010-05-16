Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab0EPXXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 19:23:08 -0400
Received: from tundra.namei.org ([65.99.196.166]:33410 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0EPXXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 19:23:05 -0400
Date: Mon, 17 May 2010 09:23:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Jean-Christophe Dubois <jcd@tribudubois.net>,
       Serge Hallyn <serue@us.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH] ima: remove ACPI dependency
In-Reply-To: <1273847996.3215.42.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1005170922350.12313@tundra.namei.org>
References: <1273011390-6090-1-git-send-email-zohar@linux.vnet.ibm.com> <1273847996.3215.42.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Mimi Zohar wrote:

> Once the 'TPM: ACPI/PNP dependency removal' patch is accepted
> http://lkml.org/lkml/2010/5/13/410, please accept this previously posted
> patch (with either updating the prereq URL or removing it.)
> 

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

> 
> On Tue, 2010-05-04 at 18:16 -0400, Mimi Zohar wrote:
> > The ACPI dependency moved to the TPM, where it belongs.  Although
> > IMA per-se does not require access to the bios measurement log,
> > verifying the IMA boot aggregate does, which requires ACPI.
> > 
> > This patch prereq's 'TPM: ACPI/PNP dependency removal'
> > http://lkml.org/lkml/2010/5/4/378.
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
> > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > Tested-by: Serge Hallyn <serue@us.ibm.com>
> > ---
> >  security/integrity/ima/Kconfig |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> > index 3d7846d..b6ecfd4 100644
> > --- a/security/integrity/ima/Kconfig
> > +++ b/security/integrity/ima/Kconfig
> > @@ -2,15 +2,14 @@
> >  #
> >  config IMA
> >  	bool "Integrity Measurement Architecture(IMA)"
> > -	depends on ACPI
> >  	depends on SECURITY
> >  	select SECURITYFS
> >  	select CRYPTO
> >  	select CRYPTO_HMAC
> >  	select CRYPTO_MD5
> >  	select CRYPTO_SHA1
> > -	select TCG_TPM
> > -	select TCG_TIS
> > +	select TCG_TPM if !S390
> > +	select TCG_TIS if TCG_TPM
> >  	help
> >  	  The Trusted Computing Group(TCG) runtime Integrity
> >  	  Measurement Architecture(IMA) maintains a list of hash
> 
> 

-- 
James Morris
<jmorris@namei.org>
