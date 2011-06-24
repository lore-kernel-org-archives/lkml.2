Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab1FXBOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:14:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39200 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1FXBOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QTcImvkVgz8QNx2XpMlqHgbaHTmm4YKiX3uYpXRvBGDgBIxOTk55iNcErGxDAw/DB+
         zDVt3scypr0Dbg6xLlRVB79tNd9NSp/iExUsgOthwtkeA+8/PlntfkyuJ3Lt8R/bwcUc
         duzyvo18RGoS5aU4jdQJZwFBGj0B7wmNdMSsY=
MIME-Version: 1.0
In-Reply-To: <B8D6CA50DACE9E4AAADE9A4D56FBAAE6166661@039-SN1MPN1-004.039d.mgd.msft.net>
References: <20110621102605.1382.90232.sendpatchset@t400s>
	<20110621102623.1382.71841.sendpatchset@t400s>
	<B8D6CA50DACE9E4AAADE9A4D56FBAAE6166661@039-SN1MPN1-004.039d.mgd.msft.net>
Date: Fri, 24 Jun 2011 10:14:06 +0900
Message-ID: <BANLkTi=QhwBAv5GtrTpitVhx+yDZPnRN+g@mail.gmail.com>
Subject: Re: [PATCH 02/02] virtio: Add virtio platform driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Bhushan Bharat-R65777 <R65777@freescale.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bhushan Bharat,

On Thu, Jun 23, 2011 at 5:54 PM, Bhushan Bharat-R65777
<R65777@freescale.com> wrote:
> What purpose this virtio platform driver serves? Are you trying to make driver layers here and each virtio device driver can hook up into this platform driver. Is that correct ?

The idea behind the virto platform driver is to have a reusable layer
that handles common virtio and vring functionality. Regular virtio
drivers for console, network and disk and interfacing to the virtio
platform driver, so these paravirtualized drivers can with this virtio
platform driver easily be reused by embedded platforms.

Vendor specific code is abstracted away from the virtio platform
driver and interfaced to using regular interrupts and SoC-specific
callbacks. So with this patch virtio can be interfaced as any regular
platform driver. This version of the driver is simply reusing the
configuration method from lguest.

If you want to see all code involved (including extremely experimental
backing drivers) then have a look at:
http://www.spinics.net/lists/linux-sh/msg07188.html

Cheers,

/ magnus
