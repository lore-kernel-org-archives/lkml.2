Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab0FQPoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:44:12 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:59730 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab0FQPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:44:10 -0400
X-IronPort-AV: E=Sophos;i="4.53,432,1272844800"; 
   d="scan'208";a="462501"
Date: Thu, 17 Jun 2010 16:42:02 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "ddutile@redhat.com" <ddutile@redhat.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>
Subject: Re: [Xen-devel] [PATCH 06/12] Allow xen platform pci device to be
 compiled as a module
In-Reply-To: <4C17A8B2.3050203@goop.org>
Message-ID: <alpine.DEB.2.00.1006171557470.3401@kaball-desktop>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com> <1275570645-27189-6-git-send-email-stefano.stabellini@eu.citrix.com> <20100614212046.GD8600@phenom.dumpdata.com> <4C17A8B2.3050203@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010, Jeremy Fitzhardinge wrote:
> On 06/14/2010 10:20 PM, Konrad Rzeszutek Wilk wrote:
> >> -static inline unsigned int max_nr_grant_frames(void)
> >> +unsigned int gnttab_max_nr_grant_frames(void)
> >>  {
> >>  	unsigned int xen_max = __max_nr_grant_frames();
> >>  
> >> @@ -444,6 +445,7 @@ static inline unsigned int max_nr_grant_frames(void)
> >>  		return boot_max_nr_grant_frames;
> >>  	return xen_max;
> >>  }
> >> +EXPORT_SYMBOL_GPL(gnttab_max_nr_grant_frames);
> >>     
> > Prefix the name with 'xen_' ? That is a mouthfull thought:
> >
> > Xen Grant Table Max Nr Grant Frames. How about 'xen_gnttab_max_frames' ?
> >   
> 
> Unfortunately the gnttab API is generally lacking xen_ prefixes.  It's
> better to keep this consistent, and then maybe sort them all out together.
> 
 

I renamed it to gnttab_max_grant_frames for now.
