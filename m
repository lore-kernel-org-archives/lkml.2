Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0HGTJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 15:09:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61369 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0HGTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 15:09:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WihnCjzppn63v3ilq0qmEqce1lXkA8FEkzY4RUpKQFZzd8qRLJiql4Yl37J4xl59l4
         hgKG1ZNqkzi4ImRVzuPV4rDFWIDnD1TN8tZcTiKtKsXBXyIoKLgvAsNyv5RHpjVHLiXJ
         XwY/qsxrYMXvT/mACiNHwJhmTNKD0B8pc7FZo=
Date: Sat, 7 Aug 2010 21:08:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] char: moxa: call disable_pci_device() if
	pci_probe() failed
Message-ID: <20100807190814.GZ9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rakib Mullick <rakib.mullick@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
References: <1281124152-12630-1-git-send-email-segooon@gmail.com> <20100807072205.GW9031@bicker> <20100807085512.GA5783@albatros> <20100807095852.GX9031@bicker> <20100807180251.GA2686@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807180251.GA2686@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 10:02:52PM +0400, Vasiliy Kulikov wrote:
> 
> The thing is not in that pci_enable_device() is nestable, but in that
> some buggy non-mainline drivers may not use PCI api, but use
> request_*(). In this case PCI bus doesn't see this driver and tries to
> call mainline driver probe(). It sees that resources are already
> grabbed. The only reason can be another driver that rules this device
> (or our kernel is crazy). As we are robust driver we don't want to break
> this buggy third party driver :-)
> 

What Jeff Garzik was saying in those days if two people called
pci_enable_device() it wasn't a problem, but if one person then called
pci_disable_device() the other person who still wanted it enabled was
screwed.  That model was "*first* person out of the building lock the
door."

That was half a decade ago though.  The fix that Jeff proposed wasn't
really a good one because there is no way people would get that right.
None of that applies any more.  These days we just call enable when we 
want it enabled and disable when we are done.  All the dependencies are
handled for us.

In fact, if we try to use the old hacks and work arounds, that will cause
bugs in the new code...

regards,
dan carpenter

