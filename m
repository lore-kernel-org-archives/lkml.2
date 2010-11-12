Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab0KLWHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 17:07:31 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:49281 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab0KLWH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 17:07:29 -0500
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
From: David Safford <safford@watson.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>
In-Reply-To: <4CDDB0A2.7090606@linux.vnet.ibm.com>
References: <1289514356.2726.18.camel@localhost.localdomain>
	 <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <6651.1289504931@redhat.com>  <22962.1289571072@redhat.com>
	 <1289573330.4341.31.camel@localhost.localdomain>
	 <4CDDB0A2.7090606@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 17:06:53 -0500
Message-ID: <1289599613.4341.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 19:24 -0200, Rajiv Andrade wrote:
> 
> Hi Dave,
> 
> On 11/12/2010 12:48 PM, David Safford wrote:
> 
> > On Fri, 2010-11-12 at 14:11 +0000, David Howells wrote:
> >> Mimi Zohar<zohar@linux.vnet.ibm.com>  wrote:
> >>
> >>>>> +	module_put(chip->dev->driver->owner);
> >>>> Where's the corresponding module_get()?  I suspect this should be wrapped to
> >>>> match tpm_chip_find_get().
> >>>>
> >>>> David
> >>> The module_get() is in tpm_chip_find_get(), which is just a helper.
> >>> (It's used this way throughout tpm.c)
> >> I'd make a function tpm_chip_find_put() just to wrap module_put() and then
> >> place it with tpm_chip_find_get() in the sources.  That makes it easier to see
> >> what's going on.
> > Or alternately rename the helper to tpm_chip_find_and_module_get()?
> > In either case, this is really up to Rajiv (the maintainer for tpm.c
> > who has already acked this patch), as this usage already appears in
> > other places in tpm.c. There would have to be a separate patch fixing
> > this for all of the instances. Rajiv, your thoughts?
> >
> > dave
> Rename the helper to tpm_chip_find_and_module_get() solves the naming issue 
> in a simpler and better way in my opinion.
> 
> Thanks,
> Rajiv

David, does this look ok to you? If so, I will do two patches, one to
fix the helper name throughout the existing tpm.c, and then a new
version of the tpm_send patch which uses the new name.

thanks
dave

