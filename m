Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1EDTjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:39:46 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:57211 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752226Ab1EDTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:39:44 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 May 2011 15:39:44 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ntDVTagpayXY24TItqpVETSj1in7tcmpMRZnqw8JraddIVO4sCJoAf33rVW252szq1jXMYMiBX9mAxwbVscVWd8NpkAn61W7O8CFksTHlQb2hD1EGWJPvjV78VKC4QcX;
Date: Wed, 4 May 2011 12:33:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <gregkh@suse.de>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv Kconfig
Message-Id: <20110504123302.1ef22682.rdunlap@xenotime.net>
In-Reply-To: <20110504185338.GB9823@suse.de>
References: <1304535105-26892-1-git-send-email-kys@microsoft.com>
	<0D753D10438DA54287A00B027084269764D295CE91@AUSP01VMBX24.collaborationhost.net>
	<20110504185338.GB9823@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 11:53:38 -0700 Greg KH wrote:

> On Wed, May 04, 2011 at 01:44:27PM -0500, H Hartley Sweeten wrote:
> > On Wednesday, May 04, 2011 11:52 AM, K. Y. Srinivasan wrote:
> > >
> > > The vmbus driver dependes on ACPI and PCI subsystems. Change 
> > > Kconfig to reflect this.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/staging/hv/Kconfig |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
> > > index 76f0756..5e0c9f6 100644
> > > --- a/drivers/staging/hv/Kconfig
> > > +++ b/drivers/staging/hv/Kconfig
> > > @@ -1,6 +1,6 @@
> > >  config HYPERV
> > >  	tristate "Microsoft Hyper-V client drivers"
> > > -	depends on X86 && m
> > > +	depends on X86 && ACPI && PCI && m
> > >  	default n
> > >  	help
> > > 	  Select this option to run Linux as a Hyper-V client operating
> > 
> > ACPI itself depends on PCI.
> 
> Still?  I thought that got removed a while ago.

Still.  Len has written in the past that technically there is no such
dependency, but in reality there is, for now at least.  IIRC.


> > It also depends on IA64 || X86.  Will the vmbus driver work with IA64?
> 
> No.
> 
> > If so the depends on could just be:
> > 
> > 	depends on ACPI && m
> 
> No, see above for the IA64 reason.
> 
> > Also, default n is redudant since n is the default anyway.
> 
> True, but it doesn't hurt either :)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
