Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab0LJAlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:41:50 -0500
Received: from web31805.mail.mud.yahoo.com ([68.142.207.68]:40441 "HELO
	web31805.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756453Ab0LJAlt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:41:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Ic39sbYX1J5hgi4bu9MlSj0oZAVCTAoP9XbsUzyVXnyB/LXkrDLUIYjDUL/OqTjwzOtULhfU3uaVi5enhddlrCd1cZ1TjK54lb60ZC4kcuUeI5HJhfkhYsdJxRQzAZiPUGH8qYiR1slphR7VBb9cVmNucVGLOmC4rGNZzeeFbq8=;
Message-ID: <186090.63629.qm@web31805.mail.mud.yahoo.com>
X-YMail-OSG: P5PWub4VM1lDlfxcvZvCTXNKKlQSozIhGlfK60a_qel66XQ
 .g_PeK6kWiNcYCXaIbf2ZAQFTKhw8Wmmjwb7E172rfJ8.oxUlQ93FUk7y79q
 WcQ8TiDTxZmMGxLBNmef9jUXFkAXavd3O3iKXbny66uCY4rEtGTOhz5if7.o
 Tcorw6weS3sb5RLr2_6AZ50r41MPx3Pd5VYBXDyq8JH6vuHuYaNRwuPLTi5M
 ZeZbJF98MrmsKHXwKOgsql6V6Ac1eUw8PXRKRdHiJPlnfcVnky0.aSCciWoQ
 ASGLEmsgmH7qBvhHQbxpNebirOZ.SNz3H.JqgmBjbRJifilIZPRRuwqJyTZO
 ApVqD7he7cB.QfB6d3vR9tjA3Qei_32bcOluCUpaa.MYTdps6hbPiT_zuVYQ
 3xBcrgyNFtFgE
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Thu, 9 Dec 2010 16:41:46 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20101210002505.GA16352@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 12/9/10, Greg KH <greg@kroah.com> wrote:
> -0800, Sarah Sharp wrote:
> > On Thu, Dec 09, 2010 at 02:54:19PM -0800, Luben Tuikov
> wrote:
> > > --- On Thu, 12/9/10, Sarah Sharp <sarah.a.sharp@linux.intel.com>
> wrote:
> > > > -0800, Luben Tuikov wrote:
> > > > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > > > > ---
> > > > >  The long story is that we see some
> host
> > > > controllers misreport their
> > > > >  PSA as they solved 2^v = streams,
> instead of
> > > > 2^(v+1) = streams. Thus
> > > > >  They report that they support 32
> streams when in
> > > > fact they support 16.
> > > > >  When the device attempts to return
> status for
> > > > stream > 15, the host
> > > > >  says ACK(NumP=0), the device goes in
> flow
> > > > control, blah, blah, this
> > > > >  module parameter allows you to set a
> max cap on
> > > > the number of streams
> > > > >  the driver will ask XHCI HCD to
> allocate.
> > > > 
> > > > If this is an issue with a host then the
> work-around should
> > > > be in the
> > > > xHCI driver instead.  It should be based on
> the
> > > > vendor/device ID of the
> > > > offending host instead of being a module
> parameter in the
> > > > UAS driver.
> > > > The only people who benefit from this patch
> are the people
> > > > "in the know"
> > > > about which hosts are buggy, not normal
> Linux users.
> > > 
> > > The OS might want to limit the number of streams
> for reasons other
> > > than a buggy HC. So this module parameter add
> flexibility other than
> > > making a buggy HC work.
> > 
> > Ok, that's fine, but my comments still stand about
> fixing this
> > particular bug in the xHCI driver, rather than in the
> UAS driver.
> 
> I agree.
> 
> Also, a module parameter will not work when your driver is
> connecting to
> different xHCI devices in the same system.  Please
> never add module
> parameters anymore, there is usually never a need for them
> at all.

I hesitated a lot before adding this module parameter. I did not want to add it since of course the obvious solution is to have a "black list" in the XHCI HCD. I think everyone knows this.

But at the time and still in some ways, it seemed like a valuable addition.  Of course, when not set (default behavior) it doesn't impact the operation of the driver.

   Luben

