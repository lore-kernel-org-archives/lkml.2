Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2BASJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:09:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:24408 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab2BASJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:09:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102048792"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: David Ahern <daahern@cisco.com>
CC: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: RE: VFs go missing with latest kernel
Thread-Topic: VFs go missing with latest kernel
Thread-Index: AQHM4Gs6ffY5XbLoAUGa1L3askdwe5YnFpYAgACgHID//3peYIAAiyUA//98+jCAARgikIAAigOA//96QVA=
Date: Wed, 1 Feb 2012 18:02:58 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F66B42@ORSMSX106.amr.corp.intel.com>
References: <4F287102.3060600@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
 <4F2887AB.8070005@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F64AF6@ORSMSX106.amr.corp.intel.com>
 <4F288C4A.3070509@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F64B7F@ORSMSX106.amr.corp.intel.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F66ADF@ORSMSX106.amr.corp.intel.com>
 <4F297D25.7090902@cisco.com>
In-Reply-To: <4F297D25.7090902@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Ahern [mailto:daahern@cisco.com]
> Sent: Wednesday, February 01, 2012 9:58 AM
> To: Rose, Gregory V
> Cc: 'LKML'
> Subject: Re: VFs go missing with latest kernel
> 
> On 02/01/2012 10:47 AM, Rose, Gregory V wrote:
> > I found this in the log file you sent me.  I had missed it yesterday.
> >
> > [   15.835223] igb 0000:07:00.0: 7 pre-allocated VFs found - override
> max_vfs setting of 7
> > [   15.835393] igb 0000:07:00.0: 7 VFs allocated
> >
> > I think that must be a bug in the code that searches for VFs already
> allocated and is the source of your problem.  I'll keep you updated on
> what I find but it has to be a bug in the VF device lookups.
> 
> Confused. What is pre-allocating the VFs during boot? Looking at my
> rc-scripts I am only set MAC addresses at boot. No VMs have been started
> yet. This setup has worked fine with Fedora 14 and 3.0 kernels; it's
> really the move to 3.3-rc that I hit the problem.

Nothing is pre-allocating the VFs.  That is the bug, the function I wrote to find pre-allocated VFs is messed up somehow.  Since it (mistakenly) thinks it's already found pre-allocated VFs, it doesn't call pci_enable_sriov() to allocate them.

- Greg

