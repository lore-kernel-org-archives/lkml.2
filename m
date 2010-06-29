Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab0F2QjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:39:05 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:28580 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849Ab0F2QjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:39:04 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Date: Tue, 29 Jun 2010 09:39:00 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100628230035.GA18971@dtor-ws.eng.vmware.com> <vcnof7-b9p.ln1@chipmunk.wormnet.eu>
In-Reply-To: <vcnof7-b9p.ln1@chipmunk.wormnet.eu>
Organization: VMware, Inc.
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006290939.00988.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Tuesday, June 29, 2010 01:27:43 am Alexander Clouter wrote:
> Dmitry Torokhov <dtor@vmware.com> wrote:
> > VMware Tools installer requires the upstream driver to be compiled
> > as a module in order to detect its presence and avoid installing
> > our own version on top of it. To avoid surprises with 2 versions
> > of the driver being installed and fighting with each other, let's
> > force the driver to be compiled as a module unless user selects
> > CONFIG_EMBEDDED.
> 
> *barf*
> 
> This surely is a problem in the installer and not the kernel?  Can you
> not nosey around in /sys/class/misc or where-ever your driver appears?

The driver does not "appear" anywhere at the moment as it does not export
any interfaces to userland. It only communicates with the hypervisor.

Unfortunately the kernel, with the exception of module parameters which
this driver does not have at the moment, does not populate
/sys/module/<modulename> for modules built into the kernel and so
installer can not rely on this data. Also, the module might be disabled
(blacklisted) by the system administrator and thus being absent from the
kernel. In such scenario we also so not want to install our version of the
driver.

> If it does not, then I would probably suggest a patch to your balloon
> driver that dumps some details in there, including module version
> information.
> 
> Eugh.

Exactly, eugh. I do not believe that dumping some unnecessary data in
sysfs is better than making driver a module.

Also, besides the installer logic, we prefer having the driver being
compiled by default as a module so that we can deliver truly urgent
fixes to customers without need of recompiling the kernel/wait for
distribution to roll out the updates/needing to reboot the box.

Thanks.

-- 
Dmitry

