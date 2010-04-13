Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0DMPSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:18:39 -0400
Received: from mxout1.idt.com ([157.165.5.25]:35371 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab0DMPSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:18:38 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 11:18:38 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3 3/6] RapidIO: Add Port-Write handling for EM
Date: Tue, 13 Apr 2010 08:00:29 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552CBCBCD@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100412204949.862b3fab.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3 3/6] RapidIO: Add Port-Write handling for EM
Thread-Index: Acravdj0C7doq8eSSwquV0V1gXv2dQAW3vOg
References: <20100406212238.GC26292@amak.tundra.com> <20100412204949.862b3fab.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexandre Bounine" <abounine@tundra.com>
Cc: <torvalds@linux-foundation.org>, <mporter@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
       <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 6 Apr 2010 17:22:38 -0400 Alexandre Bounine
<abounine@tundra.com> wrote:
> 
> >
> > From: Alexandre Bounine <alexandre.bounine@idt.com>
> >
> > Add RapidIO Port-Write message handling in the context
> > of Error Management Extensions Specification Rev.1.3.
> >
> > ...
> >
> > +static struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev
*from)
> > +{
> > +	struct list_head *n;
> > +	struct rio_dev *rdev;
> > +
> > +	WARN_ON(in_interrupt());
> 
> The check should be unneeded - lockdep will warn about this.

Thank you. I will remove it in my next set of patches. 

> 
> > +	spin_lock(&rio_global_list_lock);
> > +	n = from ? from->global_list.next : rio_devices.next;
> > +
> > +	while (n && (n != &rio_devices)) {
> > +		rdev = rio_dev_g(n);
> > +		if (rdev->comp_tag == comp_tag)
> > +			goto exit;
> > +		n = n->next;
> > +	}
> > +	rdev = NULL;
> > +exit:
> > +	spin_unlock(&rio_global_list_lock);
> > +	return rdev;
> > +}
> > +

