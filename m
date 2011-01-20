Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab1ATW7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:59:20 -0500
Received: from tundra.namei.org ([65.99.196.166]:53187 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488Ab1ATW7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:59:20 -0500
Date: Fri, 21 Jan 2011 09:59:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Michal Schmidt <mschmidt@redhat.com>
cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        eparis@redhat.com
Subject: Re: [PATCH] TPM: Long default timeout fix
In-Reply-To: <20110120154603.2bdf5d9b@alice>
Message-ID: <alpine.LRH.2.00.1101210958440.13919@tundra.namei.org>
References: <1289596730-28966-1-git-send-email-srajiv@linux.vnet.ibm.com> <20110120154603.2bdf5d9b@alice>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Michal Schmidt wrote:

> James,
> 
> what is the status of this patch from Rajiv? It has been in Fedora
> kernels for some time, but I do not see it applied upstream:

I don't know -- was it sent to me?

> 
> On Fri, 12 Nov 2010 19:18:50 -0200 Rajiv Andrade wrote:
> > If duration variable value is 0 at this point, it's because
> > chip->vendor.duration wasn't filled by tpm_get_timeouts() yet.
> > This patch sets then the lowest timeout just to give enough
> > time for tpm_get_timeouts() to further succeed.
> > 
> > This fix avoids long boot times in case another entity attempts
> > to send commands to the TPM when the TPM isn't accessible.
> > 
> > Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> > ---
> >  drivers/char/tpm/tpm.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> > index 7c41335..5635ac0 100644
> > --- a/drivers/char/tpm/tpm.c
> > +++ b/drivers/char/tpm/tpm.c
> > @@ -364,12 +364,14 @@ unsigned long tpm_calc_ordinal_duration(struct
> > tpm_chip *chip, tpm_protected_ordinal_duration[ordinal &
> >  						   TPM_PROTECTED_ORDINAL_MASK];
> >  
> > -	if (duration_idx != TPM_UNDEFINED)
> > +	if (duration_idx != TPM_UNDEFINED) {
> >  		duration = chip->vendor.duration[duration_idx];
> > -	if (duration <= 0)
> > +		/* if duration is 0, it's because
> > chip->vendor.duration wasn't */
> > +		/* filled yet, so we set the lowest timeout just to
> > give enough */
> > +		/* time for tpm_get_timeouts() to succeed */
> > +		return (duration <= 0 ? HZ : duration);
> > +	} else 
> >  		return 2 * 60 * HZ;
> > -	else
> > -		return duration;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
> >  
> 

-- 
James Morris
<jmorris@namei.org>
