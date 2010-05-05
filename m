Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565Ab0EEMZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:25:07 -0400
Received: from mxout1.idt.com ([157.165.5.25]:60786 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0EEMZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:25:02 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 4/5] RapidIO: Add switch domain routines
Date: Wed, 5 May 2010 05:24:42 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552D7E4D0@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100504162457.0c8d23ba.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 4/5] RapidIO: Add switch domain routines
Thread-Index: Acrr4NpjXxO4c0GJSfCiBlSiUIYiVwAav+Ew
References: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com><1272901558-9292-5-git-send-email-alexandre.bounine@idt.com> <20100504162457.0c8d23ba.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Matt Porter" <mporter@kernel.crashing.org>,
       "Li Yang" <leoli@freescale.com>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Thomas Moll" <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 04, 2010 7:25 PM
Andrew Morton [mailto:akpm@linux-foundation.org] wrote:
> 
> On Mon,  3 May 2010 11:45:57 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > +static int
> > +idtcps_set_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
> > +		       u8 sw_domain)
> > +{
> > +	/*
> > +	 * Switch domain configuration operates only at global level
> > +	 */
> > +	rio_mport_write_config_32(mport, destid, hopcount,
> > +				  IDTCPS_RIO_DOMAIN, (u32)sw_domain);
> > +	return 0;
> > +}
> > +
> > +static int
> > +idtcps_get_domain(struct rio_mport *mport, u16 destid, u8 hopcount,
> > +		       u8 *sw_domain)
> > +{
> > +	u32 regval;
> > +
> > +	/*
> > +	 * Switch domain configuration operates only at global level
> > +	 */
> > +	rio_mport_read_config_32(mport, destid, hopcount,
> > +				IDTCPS_RIO_DOMAIN, &regval);
> > +
> > +	*sw_domain = (u8)(regval & 0xff);
> > +
> > +	return 0;
> > +}
> 
> This ignores the return values from rio_mport_write_config_*().
> 
> AFACIT these things always return hard-wired 0 anyway.  Perhaps we
> should give up and change ->cread() and friends to return void.  That
> beats the alternative of adding lots of untestable test-n-return
> unwinding code.

We are planning to address this by properly handling return values of
these functions.
This is work in progress and we may see it published later (for entire
RapidIO subsystem).
At this moment I simply follow established trend.
    
