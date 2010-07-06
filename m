Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0GFQ2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:28:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56732 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0GFQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:28:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nvZ1Pic7cR09LBlVkU6rPz2ksLAsZANDXT85tM4U4+hr9Ppp1kj01jAsppJNPLO30t
         dX+Ogx4Fj4aY7bcRYOjYYPXsL/A3/uHkzhgVV3tKl85PlMGwz+e2WJXR4Fdd+SlMAzr1
         1o07+ot73lVigcISuxj1kQTp7DJdmUdSkFrjo=
Date: Tue, 6 Jul 2010 09:28:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>, Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Jiri Kosina <jkosina@suse.cz>, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] panasonic-laptop: fix acpi_pcc_write_sset return value
Message-ID: <20100706162842.GB9408@core.coreip.homeip.net>
References: <1278398818.12801.20.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278398818.12801.20.camel@mola>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Jul 06, 2010 at 02:46:58PM +0800, Axel Lin wrote:
> In current implementation, acpi_pcc_write_sset return 1
> if write is successful, 0 if write is failed.
> But all the callers consider acpi_pcc_write_sset return 0
> if write is successful and return negative if write is failed.
>

Yes, I think most of the times we see AE_* outside of
drivers/acpi/acpica it is an error; we should be using standard eoro
codes instead.

> This patch changes the implementation of acpi_pcc_write_sset to
> return 0 if write is successful, -1 if write is failed.

Why not use something better than -1, maybe -EIO, and the propagate that
return code up the stack?

Thanks.

-- 
Dmitry
