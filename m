Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2HMV6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:58:24 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33421 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2HMV6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:58:23 -0400
Message-ID: <1344895094.23469.37.camel@ejdallLaptop>
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor
 ID first
From: Betty Dall <betty.dall@hp.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Aug 2012 15:58:14 -0600
In-Reply-To: <20120811104352.GI2644@tassilo.jf.intel.com>
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org>
	 <1344551691.10751.12.camel@ejdallLaptop> <50259FCE.4070205@zytor.com>
	 <20120811104352.GI2644@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-11 at 03:43 -0700, Andi Kleen wrote:
> On Fri, Aug 10, 2012 at 04:57:02PM -0700, H. Peter Anvin wrote:
> > On 08/09/2012 03:34 PM, Betty Dall wrote:
> > > 
> > > I thought this should be a break instead of a continue since the code
> > > does a break if the class is 0xffffffff. If the function does not have a
> > > valid VENDOR_ID, then the remaining function numbers do not have to be
> > > scanned because functions are required to be implemented in order (no
> > > skipping a function number.)
> > > 
> > 
> > Is that true?  This is certainly not true in PCI in general: there is
> > required to be a function 0, but there is no guarantee that functions
> > 1-7 don't have gaps.
> 
> These scans are for special known devices, presumably true for them.
> 
> Anwyays if you don't like it please use v1 of the patch.
> 
> -Andi

I checked the PCI specification, and Peter is right that function
numbers can be sparse. Please go with version 1 of the patch, as Andi
suggested. I will follow up by looking at why the three scans are not
consistent and send a patch, if appropriate. The scans could be improved
by stopping the function scan if function 0 does not exist because
function 0 is required, and if it is not there then none of the other
functions will be implemented.

-Betty

