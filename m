Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2JLEtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 00:49:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59049 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2JLEtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 00:49:14 -0400
Date: Fri, 12 Oct 2012 13:49:01 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] efivarfs: Implement exclusive access for
 {get,set}_variable
Message-ID: <20121012044901.GA17913@kroah.com>
References: <1349961551.174484.910885224391.1.gpush@pecola>
 <1349962956.15966.521.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349962956.15966.521.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 02:42:36PM +0100, Matt Fleming wrote:
> On Thu, 2012-10-11 at 21:19 +0800, Jeremy Kerr wrote:
> > Currently, efivarfs does not enforce exclusion over the get_variable and
> > set_variable operations. Section 7.1 of UEFI requires us to only allow a
> > single processor to enter {get,set}_variable services at once.
> > 
> > This change acquires the efivars->lock over calls to these operations
> > from the efivarfs paths.
> > 
> > Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> > 
> > ---
> >  drivers/firmware/efivars.c |   68 +++++++++++++++++++++++--------------
> >  1 file changed, 43 insertions(+), 25 deletions(-)
> 
> Thanks, applied to 'next'.

Should this be backported to the stable kernels?

thanks,

greg k-h
