Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0F2Qkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:40:41 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:28675 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667Ab0F2Qkk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:40:40 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Date: Tue, 29 Jun 2010 09:40:38 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100628230035.GA18971@dtor-ws.eng.vmware.com> <vcnof7-b9p.ln1@chipmunk.wormnet.eu> <20100629182859.5acd5be7@neptune.home>
In-Reply-To: <20100629182859.5acd5be7@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006290940.38821.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 29, 2010 09:28:59 am Bruno Prémont wrote:
> On Tue, 29 June 2010 Alexander Clouter <alex@digriz.org.uk> wrote:
> > Dmitry Torokhov <dtor@vmware.com> wrote:
> > > VMware Tools installer requires the upstream driver to be compiled
> > > as a module in order to detect its presence and avoid installing
> > > our own version on top of it. To avoid surprises with 2 versions
> > > of the driver being installed and fighting with each other, let's
> > > force the driver to be compiled as a module unless user selects
> > > CONFIG_EMBEDDED.
> > 
> > *barf*
> > 
> > This surely is a problem in the installer and not the kernel?  Can you
> > not nosey around in /sys/class/misc or where-ever your driver appears?
> > If it does not, then I would probably suggest a patch to your balloon
> > driver that dumps some details in there, including module version
> > information.
> > 
> > Eugh.
> 
> In addition, the installer may check under /sys/module/ for it (as for
> any/most code that can be built as a module), even for built-in code.
> (if balloon driver does not show up there when built-in it would be
> better to get it to show up there)
> 

When driver is built-in the only thing exported in /sys/module/XXX are
module parameters.

We also need to handle scenario when module is not loaded into the
kernel.

Thanks.

-- 
Dmitry
