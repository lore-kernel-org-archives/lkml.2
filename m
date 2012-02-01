Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2BARrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:47:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:63952 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab2BARrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:47:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112912370"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "'David Ahern'" <daahern@cisco.com>
CC: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: RE: VFs go missing with latest kernel
Thread-Topic: VFs go missing with latest kernel
Thread-Index: AQHM4Gs6ffY5XbLoAUGa1L3askdwe5YnFpYAgACgHID//3peYIAAiyUA//98+jCAARgikA==
Date: Wed, 1 Feb 2012 17:47:30 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F66ADF@ORSMSX106.amr.corp.intel.com>
References: <4F287102.3060600@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
 <4F2887AB.8070005@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F64AF6@ORSMSX106.amr.corp.intel.com>
 <4F288C4A.3070509@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F64B7F@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C5551D9AAB213A418B7FD5E4A6F30A0702F64B7F@ORSMSX106.amr.corp.intel.com>
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
> From: Rose, Gregory V
> Sent: Tuesday, January 31, 2012 5:03 PM
> To: David Ahern
> Cc: LKML
> Subject: RE: VFs go missing with latest kernel
> 
> > -----Original Message-----
> > From: David Ahern [mailto:daahern@cisco.com]
> > Sent: Tuesday, January 31, 2012 4:50 PM
> > To: Rose, Gregory V
> > Cc: LKML
> > Subject: Re: VFs go missing with latest kernel
> >
> > On 01/31/2012 05:43 PM, Rose, Gregory V wrote:
> > >>
> > >> Back to the missing VF problem: reverting the patch I mentioned
> before
> > >> and my VM boots up fine with the even-numbered VFs assigned to it.
> > >
> > > OK, thanks... I was staring at the dmesg output you sent me and it is
> > odd because the even numbered VFs that go missing are there when you set
> > their MAC addresses.  See output below the dotted line after my reply.
> >
> > Ah, I think I confused you. The VFs for the first 2 ports (ie., the
> > first 14 VFs) are seen fine; I only showed the VFs for the second 2
> > ports -- which are missing the even number.
> >
> > So, in summary I am missing 7 VFs all associated with the even numbers
> > on the last ports of a quad port card.
> 
> OK, thanks for the clarification.  But it still shows that all 28 VFs
> exist while their MAC addresses are being set but then at some point
> subsequent to that 7 of them on the port belonging to PCI device 07:00.0
> disappear for some reason.
> 
> I'll see what I can find.

I found this in the log file you sent me.  I had missed it yesterday.

[   15.835223] igb 0000:07:00.0: 7 pre-allocated VFs found - override max_vfs setting of 7
[   15.835393] igb 0000:07:00.0: 7 VFs allocated

I think that must be a bug in the code that searches for VFs already allocated and is the source of your problem.  I'll keep you updated on what I find but it has to be a bug in the VF device lookups.

- Greg

