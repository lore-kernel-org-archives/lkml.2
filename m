Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1KIO4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:56:38 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:32560 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1KIO4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:56:37 -0500
X-IronPort-AV: E=Sophos;i="4.69,484,1315180800"; 
   d="scan'208";a="8842789"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Wed, 9 Nov 2011 14:56:42 +0000
Subject: RE: [PATCH 1/3] Introducing grant table V2 stucture
Thread-Topic: [PATCH 1/3] Introducing grant table V2 stucture
Thread-Index: Acye73UbdvaN+on5SqWNNgKu2cVKewAACtWw
Message-ID: <291EDFCB1E9E224A99088639C4762022B4543AB204@LONPMAILBOX01.citrite.net>
References: <4EBA35D3.3020506@oracle.com>
 <1320826490-29362-1-git-send-email-annie.li@oracle.com>
 <291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>
 <20111109144922.GC8410@phenom.dumpdata.com>
In-Reply-To: <20111109144922.GC8410@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd be happy with 'addr' or 'opaque' or somesuch if 'raw' is distasteful.

  Paul

> -----Original Message-----
> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: 09 November 2011 14:49
> To: Paul Durrant
> Cc: annie.li@oracle.com; xen-devel@lists.xensource.com; linux-
> kernel@vger.kernel.org; jeremy@goop.org; kurt.hackel@oracle.com
> Subject: Re: [PATCH 1/3] Introducing grant table V2 stucture
> 
> On Wed, Nov 09, 2011 at 11:11:22AM +0000, Paul Durrant wrote:
> > Annie,
> >
> >   Comments inline below...
> >
> > > -----Original Message-----
> > [snip]
> > > -static struct grant_entry *shared;
> > > +static union {
> > > +	struct grant_entry_v1 *v1;
> > > +	void *ring_addr;
> > > +} shared;
> > > +
> >
> > 'ring_addr' seems like the wrong name here; how about 'raw'?
> 
> Or 'ring'. I asked Annie to change it from 'raw' to something else
> and the first thing that came in my mind was 'ring_addr'. But this
> does not point to a ring, so the 'ring' part is wrong.
> 
> Point here is to make it descriptive. 'raw' does not carry meaning
> of _what_ it is suppose to do.
