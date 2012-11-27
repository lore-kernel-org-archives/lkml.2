Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2K0UlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:41:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45663 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039Ab2K0UlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:41:19 -0500
Date: Tue, 27 Nov 2012 20:41:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Tomas Hozza <thozza@redhat.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Message-ID: <20121127204111.GY13292@decadent.org.uk>
References: <1354027837.4266.52.camel@deadeye.wl.decadent.org.uk>
 <1758221706.1851628.1354048105347.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1758221706.1851628.1354048105347.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/3] tools/hv: Fix for long file names from readdir
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:28:25PM -0500, Tomas Hozza wrote:
> 
> 
> ----- Original Message -----
> > On Tue, 2012-11-27 at 08:56 +0100, Tomas Hozza wrote:
> > > kvp_get_if_name and kvp_mac_to_if_name copy strings into statically
> > > sized buffers which could be too small to store really long names.
> > >
> > > Buffer sizes have been changed to PATH_MAX, include "limits.h"
> > > where
> > > PATH_MAX is defined was added and length checks ware added via
> > > snprintf.
> > [...]
> > 
> > PATH_MAX has nothing to do with any actual kernel limit; it's no more
> > meaningful than the current value of 256.  Network interface names
> > are
> > limited to 15 characters, thus the current array is more than long
> > enough.  So I think this is entirely unnecessary.
> 
> This is just for sanity. The value PATH_MAX was chosen after discussion
> with K. Y. Srinivasan and Olaf Hering instead of some "magic" number like
> 256 or 512.

PATH_MAX is a magic name.

> > Using snprintf() is a good idea, but you need to check the return
> > value and handle the truncation case somehow.
> 
> By using PATH_MAX sized buffer there is no need for handling the truncation
> case.
 
You are claiming two contradictory things: sprintf() may overrun the
buffer, so we need the length check provided by snprintf(), but there
is no need to check for truncation because we know the length is
sufficient.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
