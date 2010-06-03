Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0FCJBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:01:55 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:35908 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055Ab0FCJBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:01:53 -0400
Date: Thu, 3 Jun 2010 11:01:41 +0200
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jacob Pan <jacob.jun.pan@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, i8259: Only register sysdev for real PIC
Message-ID: <20100603090141.GA15516@os.inf.tu-dresden.de>
References: <20100602113150.GB21413@os.inf.tu-dresden.de>
 <20100602181814.63b173be.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100602181814.63b173be.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed Jun 02, 2010 at 18:18:14 -0700, Andrew Morton wrote:
> On Wed, 2 Jun 2010 13:31:50 +0200 Adam Lackorzynski <adam@os.inf.tu-dresden.de> wrote:
> 
> > Do not register the sysdev function when the null_legacy_pic is used so
> > that the i8259 resume, suspend and shutdown functions are not called.
> 
> What are the effects of this change?  Does it fix an oops or a hang, or
> nothing at all, or...?
 
My platform makes use of the null_legacy_pic choice and oopses when
doing a shutdown as the shutdown code goes through all the registered
sysdevs and calls their shutdown method which in my case poke on a
non-existing i8259. Imho the i8259 specific sysdev should only be
registered if the i8259 is actually there.


Adam
