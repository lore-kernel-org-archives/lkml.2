Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2CVKoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:44:44 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:35933 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2CVKon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:44:43 -0400
X-IronPort-AV: E=Sophos;i="4.73,629,1325462400"; 
   d="scan'208";a="11469566"
Date: Thu, 22 Mar 2012 10:44:46 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen/xenbus: Add quirk to deal with misconfigured
 backends.
In-Reply-To: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.00.1203221040030.15151@kaball-desktop>
References: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Konrad Rzeszutek Wilk wrote:
> A rather annoying and common case is when booting a PVonHVM guest
> and exposing the PV KBD and PV VFB - as both of those do not
> make any sense. The HVM guest is using the VGA driver and the emulated
> keyboard for this. So we provide a very basic quirk framework
> (can be expanded in the future) to not wait for 6 minutes for those devices
> to initialize - they never wont.
> 
> To trigger this, put this in your guest config:
> 
> vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> 
> instead of this:
> vnc=1
> vnclisten="0.0.0.0"

While I do understand the issue you are trying to solve, it actually
makes sense to have PV KBD (and PV VFB maybe in the future) in a PVonHVM
guest. In particular PV KVB is already enabled in upstream QEMU for
PVonHVM guests because it allows users to have a keyboard and mouse
without USB emulation, that requires lots of wakes up in QEMU.

Maybe we could just reduce the timeout in general for all the PV
devices? After all, why are we waiting 6 minutes? I could understand 6
seconds, but 6 minutes seem really too much.
