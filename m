Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161290Ab2COThO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:37:14 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:8576 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031784Ab2COThK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:37:10 -0400
From: "Clark, Liz" <liz.clark@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 Mar 2012 19:36:34 +0000
Subject: RE: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
Thread-Topic: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
Thread-Index: Ac0C3TKqXUdWjo0hQzCQspJXTJRe7AABIgsw
Message-ID: <51D3961FBAB878428126A3DD5A715A3A60EA9094CE@GVW1338EXA.americas.hpqcorp.net>
References: <1331832809-4484-1-git-send-email-liz.clark@hp.com>
 <20120315185514.GB11142@kroah.com>
In-Reply-To: <20120315185514.GB11142@kroah.com>
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

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, March 15, 2012 11:55 AM
> To: Clark, Liz
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] TTY: Wrong unicode value copied in
> con_set_unimap()
> 
> On Thu, Mar 15, 2012 at 10:33:29AM -0700, Liz Clark wrote:
> > Bugzilla 40012: PIO_UNIMAP bug: error updating Unicode-to-font map
> >
> > The unicode font map for the virtual console is a 32x32x64 table
> which
> > allocates rows dynamically as entries are added.  The unicode value
> > increases sequentially and should count all entries even in empty
> > rows.  The defect is when copying the unicode font map in
> con_set_unimap(),
> > the unicode value is not incremented properly.  The wrong unicode
> value
> > is entered in the new font map.
> >
> > Signed-off-by: Liz Clark <liz.clark@hp.com>
> 
> Is this a new problem caused by recent changes in this area, or has it
> always been there and needs to be backported to older kernels to solve
> the problem there?
> 
> thanks,
> 
> greg k-h


The code with the defect was introduced in v2.1.112.  Prior to that the fontmap was not copied at all in con_set_unimap().


Liz
