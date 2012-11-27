Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2K0U2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:28:43 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:51331 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab2K0U2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:28:42 -0500
Date: Tue, 27 Nov 2012 15:28:25 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Message-ID: <1758221706.1851628.1354048105347.JavaMail.root@redhat.com>
In-Reply-To: <1354027837.4266.52.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/3] tools/hv: Fix for long file names from readdir
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.36.7.189]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Tue, 2012-11-27 at 08:56 +0100, Tomas Hozza wrote:
> > kvp_get_if_name and kvp_mac_to_if_name copy strings into statically
> > sized buffers which could be too small to store really long names.
> >
> > Buffer sizes have been changed to PATH_MAX, include "limits.h"
> > where
> > PATH_MAX is defined was added and length checks ware added via
> > snprintf.
> [...]
> 
> PATH_MAX has nothing to do with any actual kernel limit; it's no more
> meaningful than the current value of 256.  Network interface names
> are
> limited to 15 characters, thus the current array is more than long
> enough.  So I think this is entirely unnecessary.

This is just for sanity. The value PATH_MAX was chosen after discussion
with K. Y. Srinivasan and Olaf Hering instead of some "magic" number like
256 or 512.

> Using snprintf() is a good idea, but you need to check the return
> value and handle the truncation case somehow.

By using PATH_MAX sized buffer there is no need for handling the truncation
case.


Tomas Hozza
