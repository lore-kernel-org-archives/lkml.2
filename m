Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1KRSFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:05:20 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47450 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1KRSFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:05:18 -0500
Date: Fri, 18 Nov 2011 13:05:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: annie li <annie.li@oracle.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/granttable: Grant tables V2
 implementation
Message-ID: <20111118180500.GA19469@phenom.dumpdata.com>
References: <4EC3B62F.6080702@oracle.com>
 <1321451372-13596-1-git-send-email-annie.li@oracle.com>
 <4EC62FE5.2080608@oracle.com>
 <1321614166.3664.311.camel@zakaz.uk.xensource.com>
 <20111118135221.GC12433@phenom.dumpdata.com>
 <1321624845.3664.354.camel@zakaz.uk.xensource.com>
 <4EC6837F.1050201@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC6837F.1050201@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4EC69E59.011E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So we have two candidates:
> xen_raw_printk + panic
> panic + earlyprintk=xen
> 
> If panic does work with earlyprintk, then the latter one is better.
> Otherwise, there will be duplicated string printed out with
> 'earlyprintk=xen'.

The idea is just to have one function. Whichever prints the
string and panics the machine. If 'panic' does this properly
(and properly meaning it actually prints data when using
the earlyprintk=xen as well as console=hvc0) printout system
the we cuold just use 'panic' and not worry about it.


But if it does not, then we (and by we I mean you) should 
provide a variant of panic() that prints the data properly using the 
earlprintk mechanism. Preferrabily to make it generic.

