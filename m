Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab2GMNWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646Ab2GMNWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:22:19 -0400
Date: Fri, 13 Jul 2012 16:22:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Subject: Re: UIO: missing resource mapping
Message-ID: <20120713132223.GA10959@redhat.com>
References: <4FFE7C1F.7080702@gmx.net>
 <20120712194432.GA2592@local>
 <20120712231632.GC9317@redhat.com>
 <1342166955.6607.5.camel@blech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342166955.6607.5.camel@blech>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 10:09:15AM +0200, Dominic Eschweiler wrote:
> Am Freitag, den 13.07.2012, 02:16 +0300 schrieb Michael S. Tsirkin:
> > My concern was people will ask for more and more stuff that pci
> > sysfs already has.
> > If we do add these is there a way to not duplicate code from pci? 
> 
> I have some concerns about the placing for the BAR mapping code inside
> the kernel. The point is, that sysfs currently makes it possible to map
> BARs of all card which are handled by any driver. This is fine in case
> of UIO, because it is intended that a user-space program maps BARs, but
> it is also possible to map BARs that are already handle by a kernel
> driver. It i therefore possible to jam the system by confusing sysfs
> entries.
> 
> I don't know which implications this has, but I would move the BAR
> mapping capabilities completely to UIO. This should ensure that only
> BARs can be mapped, which are handled by UIO and no other kernel-space
> driver.

Could you give an example of the problem? How do you bind
both UIO and another driver to the same device?

-- 
MST
