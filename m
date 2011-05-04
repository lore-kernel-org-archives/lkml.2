Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1EDSsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:48:19 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:44033 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1EDSsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:48:16 -0400
From: KY Srinivasan <kys@microsoft.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv	Kconfig
Thread-Topic: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv	Kconfig
Thread-Index: AQHMCotVUFFyEri7NUqyHWEhFI9/K5R9Abgw
Date: Wed, 4 May 2011 18:48:15 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DFE27@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1304535105-26892-1-git-send-email-kys@microsoft.com>
 <0D753D10438DA54287A00B027084269764D295CE91@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B027084269764D295CE91@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H Hartley Sweeten [mailto:hartleys@visionengravers.com]
> Sent: Wednesday, May 04, 2011 2:44 PM
> To: KY Srinivasan; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Cc: Haiyang Zhang
> Subject: RE: [PATCH 1/1] Staging: hv: Add the necessary dependencies to hyperv
> Kconfig
> 
> On Wednesday, May 04, 2011 11:52 AM, K. Y. Srinivasan wrote:
> >
> > The vmbus driver dependes on ACPI and PCI subsystems. Change
> > Kconfig to reflect this.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
> > index 76f0756..5e0c9f6 100644
> > --- a/drivers/staging/hv/Kconfig
> > +++ b/drivers/staging/hv/Kconfig
> > @@ -1,6 +1,6 @@
> >  config HYPERV
> >  	tristate "Microsoft Hyper-V client drivers"
> > -	depends on X86 && m
> > +	depends on X86 && ACPI && PCI && m
> >  	default n
> >  	help
> > 	  Select this option to run Linux as a Hyper-V client operating
> 
> ACPI itself depends on PCI.  It also depends on IA64 || X86.  Will the
> vmbus driver work with IA64?  If so the depends on could just be:
> 
> 	depends on ACPI && m

Good point; vmbus will not work on IA64 though. So, minimally we would want 
X86 && ACPI. I will resend this with this change.

Regards,

K. Y
> 
> Also, default n is redudant since n is the default anyway.
> 
> Regards,
> Hartley

