Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2KWN33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:29:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2KWN31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:29:27 -0500
Date: Fri, 23 Nov 2012 11:29:20 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Ram Pai <linuxram@us.ibm.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Worsley <amworsley@gmail.com>,
        Michal Ludvig <mludvig@logix.net.nz>
Subject: Re: [ 37/38] PCI : ability to relocate assigned pci-resources
Message-ID: <20121123132919.GA3759@herton-Z68MA-D2H-B3>
References: <20121122003904.262382971@linuxfoundation.org>
 <20121122003908.400731657@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122003908.400731657@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 04:40:20PM -0800, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ram Pai <linuxram@us.ibm.com>
> 
> commit 2bbc6942273b5b3097bd265d82227bdd84b351b2 upstream.
> 
> Currently pci-bridges are allocated enough resources to satisfy their immediate
> requirements.  Any additional resource-requests fail if additional free space,
> contiguous to the one already allocated, is not available. This behavior is not
> reasonable since sufficient contiguous resources, that can satisfy the request,
> are available at a different location.
> 
> This patch provides the ability to expand and relocate a allocated resource.
> 
> 	v2: Changelog: Fixed size calculation in pci_reassign_resource()
> 	v3: Changelog : Split this patch. The resource.c changes are already
> 			upstream. All the pci driver changes are in here.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Andrew Worsley <amworsley@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This change is said to bring a regression:
http://comments.gmane.org/gmane.linux.kernel.pci/11666

fixed by:
commit 47ea91b4052d9e94b9dca5d7a3d947fbebd07ba9
Resource: fix wrong resource window calculation

Which wasn't applied with this series for 3.0.

-- 
[]'s
Herton
