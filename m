Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2GMIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:09:29 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:55455 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2GMIJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:09:18 -0400
Message-ID: <1342166955.6607.5.camel@blech>
Subject: Re: UIO: missing resource mapping
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Andreas Schallenberg <embedded@gmx.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org
Date: Fri, 13 Jul 2012 10:09:15 +0200
In-Reply-To: <20120712231632.GC9317@redhat.com>
References: <4FFE7C1F.7080702@gmx.net> <20120712194432.GA2592@local>
	 <20120712231632.GC9317@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 13.07.2012, 02:16 +0300 schrieb Michael S. Tsirkin:
> My concern was people will ask for more and more stuff that pci
> sysfs already has.
> If we do add these is there a way to not duplicate code from pci? 

I have some concerns about the placing for the BAR mapping code inside
the kernel. The point is, that sysfs currently makes it possible to map
BARs of all card which are handled by any driver. This is fine in case
of UIO, because it is intended that a user-space program maps BARs, but
it is also possible to map BARs that are already handle by a kernel
driver. It i therefore possible to jam the system by confusing sysfs
entries.

I don't know which implications this has, but I would move the BAR
mapping capabilities completely to UIO. This should ensure that only
BARs can be mapped, which are handled by UIO and no other kernel-space
driver.

-- 
Gruß
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Straße 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 69 79844114

