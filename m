Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0KKW0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:26:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42380 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0KKW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:26:05 -0500
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <6651.1289504931@redhat.com>
References: <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <6651.1289504931@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 17:25:56 -0500
Message-ID: <1289514356.2726.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 19:48 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Reviewd-by: Mimi Zohar <zohar@watson.ibm.com>
> 
> You've missed an 'e'.

thanks, will fix

> > +int tpm_send(u32 chip_num, char *cmd, int buflen)
> > +{
> > ...
> > +	rc = transmit_cmd(chip, (struct tpm_cmd_t *)cmd, buflen,
> > +			  "attempting tpm_cmd");
> 
> Make cmd 'void *' to obviate the cast.  Preferably it should be const too.

will do

> > +	module_put(chip->dev->driver->owner);
> 
> Where's the corresponding module_get()?  I suspect this should be wrapped to
> match tpm_chip_find_get().
> 
> David

The module_get() is in tpm_chip_find_get(), which is just a helper.
(It's used this way throughout tpm.c)

thanks,

Mimi

