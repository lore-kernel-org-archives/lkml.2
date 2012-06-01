Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab2FAP4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:56:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47825 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085Ab2FAPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:55:57 -0400
Date: Fri, 1 Jun 2012 15:03:06 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 05/91] iwlwifi: use 6000G2B for 6030 device series
Message-ID: <20120601070306.GC13229@kroah.com>
References: <20120527002508.028566430@linuxfoundation.org>
 <1338125678.20487.69.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338125678.20487.69.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 02:34:38PM +0100, Ben Hutchings wrote:
> On Sun, 2012-05-27 at 09:25 +0900, Greg KH wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > commit 35e7adaaf6932c5ffb22c6ec521734434c65adc5 upstream.
> > 
> > "iwlwifi: use correct released ucode version" change
> > the ucode api ok from 6000G2 to 6000G2B, but it shall belong
> > to 6030 device series, not the 6005 device series. Fix it
> 
> The relevant changes are:
> 
> (a)
> commit e377a4fc768d7d477e58888bdbddd0103d6238bf
> Author: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> Date:   Sun Apr 22 07:55:27 2012 -0700
> 
>     iwlwifi: use correct released ucode version
> 
> - changed IWL_DEVICE_6005 to use IWL6000G2B_UCODE_API_OK
> - upstream in this merge window; not cc'd to stable; redundant with next change
> 
> (b)
> commit 78cbcf2b9dbe0565820dc7721316f9c401000a68
> Author: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> Date:   Sun Apr 22 07:55:27 2012 -0700
> 
>     iwlwifi: use correct released ucode version
> 
> - changed IWL_DEVICE_6005 to use IWL6000G2B_UCODE_API_OK (among many other changes)
> - upstream in 3.4; cc'd to stable; applied in 3.2.17 and 3.3.5
> 
> (c)
> commit 35e7adaaf6932c5ffb22c6ec521734434c65adc5
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Wed Apr 25 08:10:08 2012 -0700
> 
>     iwlwifi: use 6000G2B for 6030 device series
> 
> - changed IWL_DEVICE_6005 back to IWL6000G2_UCODE_API_OK
> - upstream in this merge window; cc'd to stable; redundant with next change
> 
> (d)
> commit 1ed2ec37b44e86eaa8e0a03b908a39c80f65ee45
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Wed Apr 25 08:10:08 2012 -0700
> 
>     iwlwifi: use 6000G2B for 6030 device series
> 
> - changed IWL_DEVICE_6005 back to IWL6000G2_UCODE_API_OK and IWL_DEVICE_6030 to IWL6000G2B_UCODE_API_OK
> - upstream in 3.4; cc'd to stable; applied in 3.2.17 and 3.3.5
> 
> We have applied (b) and (d); (a) and (c) are thus redundant.
> 
> This is (a) but applied in the wrong place; the next patch (06/91) is
> (c) but applied in the wrong place; together they are reverting the
> effect of (d)).

Ugh, messy.  I've now removed both of these from the 3.4 stable queue,
thanks.

greg k-h
