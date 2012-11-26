Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2KZSyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:54:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:57037 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2KZSyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:54:02 -0500
Date: Mon, 26 Nov 2012 10:53:59 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Worsley <amworsley@gmail.com>,
        Michal Ludvig <mludvig@logix.net.nz>
Subject: Re: [ 37/38] PCI : ability to relocate assigned pci-resources
Message-ID: <20121126185359.GD21012@kroah.com>
References: <20121122003904.262382971@linuxfoundation.org>
 <20121122003908.400731657@linuxfoundation.org>
 <20121123132919.GA3759@herton-Z68MA-D2H-B3>
 <20121124014141.GD2752@ram.oc3035372033.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124014141.GD2752@ram.oc3035372033.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 09:41:41AM +0800, Ram Pai wrote:
> On Fri, Nov 23, 2012 at 11:29:20AM -0200, Herton Ronaldo Krzesinski wrote:
> > On Wed, Nov 21, 2012 at 04:40:20PM -0800, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Ram Pai <linuxram@us.ibm.com>
> > > 
> > > commit 2bbc6942273b5b3097bd265d82227bdd84b351b2 upstream.
> > > 
> > > Currently pci-bridges are allocated enough resources to satisfy their immediate
> > > requirements.  Any additional resource-requests fail if additional free space,
> > > contiguous to the one already allocated, is not available. This behavior is not
> > > reasonable since sufficient contiguous resources, that can satisfy the request,
> > > are available at a different location.
> > > 
> > > This patch provides the ability to expand and relocate a allocated resource.
> > > 
> > > 	v2: Changelog: Fixed size calculation in pci_reassign_resource()
> > > 	v3: Changelog : Split this patch. The resource.c changes are already
> > > 			upstream. All the pci driver changes are in here.
> > > 
> > > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > Cc: Andrew Worsley <amworsley@gmail.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This change is said to bring a regression:
> > http://comments.gmane.org/gmane.linux.kernel.pci/11666
> > 
> > fixed by:
> > commit 47ea91b4052d9e94b9dca5d7a3d947fbebd07ba9
> > Resource: fix wrong resource window calculation
> > 
> > Which wasn't applied with this series for 3.0.
> 
> You are right.  We need to apply that fix along with this patch.

Thanks, now added to the tree.

greg k-h
