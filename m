Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2DWPQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:16:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28452 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2DWPQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:16:48 -0400
Date: Mon, 23 Apr 2012 11:11:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
Message-ID: <20120423151123.GC24481@phenom.dumpdata.com>
References: <1334913957.2863.1.camel@hp6530s>
 <4F913340.4000202@citrix.com>
 <1334920396.2863.16.camel@hp6530s>
 <1334925508.28331.63.camel@zakaz.uk.xensource.com>
 <20120420164150.GC31062@phenom.dumpdata.com>
 <CAF1ivSamaYzQDwjFqRGrnQ+fCr0D4vLGuG4JRBZ3_GD_y8yY=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAF1ivSamaYzQDwjFqRGrnQ+fCr0D4vLGuG4JRBZ3_GD_y8yY=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > How about return -1 on error?
> >> > The calling function can check -1 for error.
> >>
> >> Isn't -1 potentially (at least theoretically) a valid value to read from
> >> one of these registers?
> >
> > Yeah, but then we are back to crashing at bootup (with dom0) :-)
> >
> > Perhaps the fallback is to emulate (so retain some of the original code)
> > as we have been since .. uh 3.0?
> 
> Do you mean the return value of io_apic_read in 3.0?

No. I meant that we would continue to emulate. The improvement
is that now we do:

      if (reg == 0x1)
              return 0x00170020;
      else if (reg == 0x0)
              return apic << 24;

instead of 0xfdfdfdfd.

> It's 0xffffffff.

Now it is 0xfdfdfdfd.

I am suggesting that instead of BUG_ON(), we fallback to do returning
an emulatated IO_APIC values - like the ones that this original patch
cooked up..
