Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab0F3T1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:27:11 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:23785 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab0F3T1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:27:09 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Date: Wed, 30 Jun 2010 12:27:08 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <AANLkTimmIG6GF-hKBk7JsZpvZNEAj1Tlt4GrPXexN0_0@mail.gmail.com>
In-Reply-To: <AANLkTimmIG6GF-hKBk7JsZpvZNEAj1Tlt4GrPXexN0_0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301227.08709.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chetan,

On Wednesday, June 30, 2010 11:42:53 am Chetan Loke wrote:
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Dmitry Torokhov
> > Sent: June 28, 2010 7:01 PM
> > VMware Tools installer requires the upstream driver to be compiled
> > as a module in order to detect its presence and avoid installing
> > our own version on top of it. To avoid surprises with 2 versions
> > of the driver being installed and fighting with each other, let's
> > force the driver to be compiled as a module unless user selects
> > CONFIG_EMBEDDED.
> > 
> >  config VMWARE_BALLOON
> >  
> >  	tristate "VMware Balloon Driver"
> > 
> > -	depends on X86
> > +	depends on X86 && (EMBEDDED || m)
> 
> None of the following questions are related to this patch.
> 
> Q1)Does vmtools handle pvscsi correctly?
> 

Yes, as long as it compiled as a module or installer will not overwrite
distribution-supplied version unless user explicitly requests installer
to clobber it.

So far distributions have not tried building their kernels with pvscsi
or vmxnet3 built-in, but did so with our ballon driver, which prompted
this particular change.

> Q2)In case if a VM wants to be a good citizen, is there a way for a
> guest to know about the balloon-event?

I am not sure I follow. Ballooning supposed to be as transparent as
possible...

> 
> Q3)What if an app mlock's its memory resources and driver's have
> pinned down their pages then how does inflation work?

We will inflate as much as we can. Obviously if there are no more
memory balloon may not grow to its full target size.

Balloon driver communicates to the hypervisor the total amount of
memory in the guest, we may want to adjust that number by subtracting
memory allocated by the kernel, mlocked memory and so on, but it is
not done currently.

Thanks.

-- 
Dmitry
> 
> 
> regards
> Chetan Loke
