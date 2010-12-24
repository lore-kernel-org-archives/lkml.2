Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab0LXVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 16:16:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63179 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0LXVQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 16:16:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=I6b4kOTZyCE0Eshh6rtVGIFCh3GmPrUMyNv3f2nawi0JUZCcaRVpxEeXZ7QSLFNveJ
         5xYAH7cdF4lCMhsrdpGMqlfO4VzNXmcpq7R+f+I0zzXBsLhwKP6E6F0hW0W3q77Nx04p
         wEiGLQ+IHbTTob+pANXDj8pFhII/sDlfh3tv4=
Date: Sat, 25 Dec 2010 00:16:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: taskstats alignment...
Message-ID: <20101224211529.GA19019@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jeff Mahoney <jeffm@suse.com>, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>
References: <20101223.093022.193727098.davem@davemloft.net>
 <4D14EA49.3070005@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D14EA49.3070005@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 01:45:29PM -0500, Jeff Mahoney wrote:
v> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/23/2010 12:30 PM, David Miller wrote:
> > 
> > Re: commit 4be2c95d1f7706ca0e74499f2bd118e1cee19669
> > 
> > Pretty much every 64-bit architecture other than
> > powerpc64 and x86-64 needs that code, not just
> > IA64.
> > 
> > Better check would be:
> > 
> > CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > 
> > Otherwise we'll be twiddling that ifdef endlessly as each
> > and every other 64-bit platform bumps into this issue.
> > 
> > So please could you change this to use a more sane check?
> 
> I don't have an objection to it, but I've been pushing that we make the
> change universal from the beginning of the discussion.
> 
> The issue is that it causes breakage on apps that aren't following the
> interface properly. iotop, in particular, has hard-coded offsets into
> the packet to fish out the taskstats structure.
> 
> So, if the goal of not breaking x86_64 is good enough, I'm fine with
> this change.

Didn't you say something along the lines that if they don't have
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS then there is a warning message
printed in dmesg?  I thought that was what prompted you to change the
alignment in the first place.  It sound like those arches are already
broken so David's suggestion would be a clear improvement over the 
current code.

BTW, since you're redoing the patch, it would be good if you pasted the
warning message into the changelog.

regards,
dan carpenter

