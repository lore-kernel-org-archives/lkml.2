Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0H3RZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:25:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23844 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0H3RZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:25:55 -0400
Date: Mon, 30 Aug 2010 10:25:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
        Miguel Calleja <mcalleja1@telecable.es>,
        LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Shirish S Pargaonkar <shirishp@us.ibm.com>
Subject: Re: Linux 2.6.36-rc3
Message-Id: <20100830102527.17d5e1f1.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com>
	<i5fr6h$ih6$1@dough.gmane.org>
	<4C7BE3AE.8020204@suse.de>
	<AANLkTi=S3E80edLwAAAOwehrakYVgeKzC+yKptwJJZLc@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 12:14:53 -0500 Shirish Pargaonkar wrote:

> On Mon, Aug 30, 2010 at 12:00 PM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> > (Cc linux-cifs@vger.kernel.org)
> >
> > Couldn't get a chance to check this, but I guess this is perhaps due to
> > the recent crypto patches..
> 
> Suresh, yes, cifs auth and signing code using kernel crypto (shash) apis.
> 
> fs/cifs/Kconfig
> 
>         select CRYPTO_MD5
>         select CRYPTO_ARC4
> 

Either CIFS should depend on CRYPTO:
change
	depends on INET
to
	depends on INET && CRYPTO

or it can also select CRYPTO.

> 
> >
> > On 08/30/2010 02:17 PM, Miguel Calleja wrote:
> >> CIFS does not build without CRYPTO selected.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
