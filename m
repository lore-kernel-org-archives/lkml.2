Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2ITN1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:27:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2ITN1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:27:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: introduce a DTS for Xen unprivileged virtual machines
Date: Thu, 20 Sep 2012 13:27:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
References: <1348076658-4511-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1209201240110.29232@kaball.uk.xensource.com> <1348143533.26501.28.camel@zakaz.uk.xensource.com>
In-Reply-To: <1348143533.26501.28.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209201327.45802.arnd@arndb.de>
X-Provags-ID: V02:K0:MbamWzyfXUWMJ4bda6+S6Fl6++JJwT+lvfOV1RSoIMq
 fblgtv0+qKgmgbvcArD1nwhvEElfTCXnkzOxIZunO8hxtz/X61
 hUe5TmeAQEdrkxP1HkJnHRFkO94UhGLlZCS9bKCL7aA4bCGF6q
 xBNxffC20ZQBTIJemklzXDtCReJCUD46RCHqmvk6qaiQOnv7Se
 MwcpF491XefSCKBlEGE7px9eJbnMINpFeLsKkGah/OPs/9n+9I
 3NYD7yvkzz4uUH+6eokrYcGUMMVrev8+BNUiDTD483lf3g5+IB
 oY+93PV4dM5Xgx6TAhD4kzkpnoOL3sr3Q800ynTBB0HdC1IsOQ
 ZbBxse1F0TI+qiM+Ribk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2012, Ian Campbell wrote:
> On Thu, 2012-09-20 at 12:56 +0100, Stefano Stabellini wrote:
> > On Thu, 20 Sep 2012, Ian Campbell wrote:
> > > On Wed, 2012-09-19 at 18:44 +0100, Stefano Stabellini wrote:

> > > > + compatible = "xen,xenvm-4.2", "arm,vexpress";
> > > 
> > > Is this second compatible thing actually true? We don't actually emulate
> > > much (anything?) of what would be on a real vexpress motherboard.
> > > 
> > > "arm,vexpress" is used only in v2m.c and I don't think we want the
> > > majority of that -- we don't provide any of the peripherals which it
> > > registers.
> > > 
> > > I think the only things we might want out of that lot are the arch timer
> > > and perhaps the uart0 (as a debug port).
> > > 
> > > I suspect we should have our own xen machine .c.
> > > 
> > > [...]
> > 
> > It is true that we are "arm,vexpress" compatible at the moment.
> 
> But we aren't, we don't emulate 90%+ of the actual hardware which
> vexpress compatibility would actually imply.
> 
> Look in arch/arm/mach-vexpress/v2m.c, which is the only thing keyed off
> this compat value -- it's full of stuff which we don't (and aren't going
> to) implement.

It's not much different in the end, but I think I'd rather make the
compatible list in the device tree "xen,xenvm-4.2", "xen,xenvm" without
listing "arm,vexpress", but then adding "xen,xenvm" to the list of
compatible devices in the vexpress kernel code.

The main difference is that if we decide to separate out the Linux
code for Xen and vexpress later into distinct ports, we have the
option to do that. vexpress will support multiplatform configurations
in 3.7 anyway, so the idea of making all virtual platforms part of
vexpress in order to be able to boot the same kernel on them is not
all that important any more.

	Arnd
