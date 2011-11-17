Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab1KQQaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:30:13 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:46659 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1KQQaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:30:12 -0500
Date: Thu, 17 Nov 2011 11:29:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: annie li <annie.li@oracle.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [PATCH 1/3] xen/granttable: Introducing grant table V2 stucture
Message-ID: <20111117162955.GA6758@phenom.dumpdata.com>
References: <4EC3B62F.6080702@oracle.com>
 <1321451304-13559-1-git-send-email-annie.li@oracle.com>
 <1321526148.3664.263.camel@zakaz.uk.xensource.com>
 <4EC53119.7060307@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC53119.7060307@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EC5368E.00A4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >The more normal way to do this would be to make gnttab_interface a
> >pointer, define gnttab_v1_ops and do:
> >	gnttab_interface = &gnttab_v1_ops;
> >or if the pointer overhead is significant remove that and just do a
> >struct assignment:
> >	gnttab_interface = gnttab_v1_ops;
> >
> If using this way, we need two more public structures(gnttab_v1_ops
> and gnttab_v2_ops), and two more functions to initialize those two
> structures and then initialize the pointer gnttab_interface. It is
> more complicated, am i missing something?

Why two functions? I agree on the structures - but they need not to be
public (they can be static).

For a good example look at how apic_physflat is done.
