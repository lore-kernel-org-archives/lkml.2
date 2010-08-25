Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab0HYR26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:28:58 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:55781 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab0HYR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:28:56 -0400
X-Greylist: delayed 11861 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 13:28:56 EDT
Date: Wed, 25 Aug 2010 18:28:52 +0100
From: Colin Watson <cjwatson@canonical.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] Add new linearfb driver
Message-ID: <20100825172851.GL21862@riva.ucam.org>
References: <20100825141111.GI21862@riva.ucam.org> <20100825190438.55ecb34d@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100825190438.55ecb34d@neptune.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Originating-Smarthost02-IP: [82.69.40.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 07:04:38PM +0200, Bruno Prémont wrote:
> On Wed, 25 August 2010 Colin Watson <cjwatson@canonical.com> wrote:
> > -config FB_EFI
> > -	bool "EFI-based Framebuffer Support"
> > -	depends on (FB = y) && X86 && EFI
> > +config FB_LINEAR
> > +	bool "Simple linear framebuffer support"
> > +	depends on FB
> >  	select FB_CFB_FILLRECT
> >  	select FB_CFB_COPYAREA
> >  	select FB_CFB_IMAGEBLIT
>         ^^^^^^^^^^^^^^^^^^^^^^^
> 
> > +config FB_EFI
> > +	bool "EFI-based Framebuffer Support"
> > +	depends on (FB = y) && X86 && EFI
> > +	select FB_LINEAR
>         ^^^^^^^^^^^^^^^^
>   Has kconfig been adjusted to process select recursively?
>   If not the selects from FB_LINEAR will have to be copied here.

When I start with a consistent .config with FB_CFB_FILLRECT unset, then
'make menuconfig' and enable FB_EFI, the resulting .config has
CONFIG_FB_CFB_FILLRECT=y.  That should be a sufficient test, shouldn't
it?

Thanks,

-- 
Colin Watson                                    [cjwatson@canonical.com]
