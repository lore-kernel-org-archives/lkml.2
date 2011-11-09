Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1KIOyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:54:32 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49730 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab1KIOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:54:20 -0500
Date: Wed, 9 Nov 2011 09:22:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ANNIE LI <annie.li@oracle.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org, jeremy@goop.org,
        Kurt Hackel <Kurt.Hackel@oracle.com>,
        Paul Durrant <paul.durrant@citrix.com>
Subject: Re: patches of upstreaming grant table version 2
Message-ID: <20111109142256.GA8410@phenom.dumpdata.com>
References: <4EBA32B7.7020804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA32B7.7020804@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EBA9417.00EA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 03:58:47PM +0800, ANNIE LI wrote:
> Hi
> 
> The following patches introduce and implement grant table version 2,
> and they are based on v3.1.0-rc9+.

Yeey! Thanks for posting them.
> 
> Descriptions for those patches:
> 
> 1. In those patches, the grant table code supports both grant table
> v1 and v2 version, v2 is an extension from v1. Grant table of guest
> domain can be either v1 or v2 version, and every grant table entry
> on one guest should be the same version.
> 
> 2. Full page structure of grant table v2 play the same role as grant
> table v1. Although full page structure is different from v1, grant
> table 2 is totally backwards compatible with v1. Grant table is
> shared between guest and Xen, domu and dom0 all have their own grant
> table shared with Xen, and their grant table version should be set
> before any grants are activated. When domu grants an entry to dom0
> to map a frame, following are steps:
> * domu introduces a grant entry by reference
> * domu informs dom0 the gref
> * dom0 sends hypercall to map frame through this reference, Xen copy
> shared entry to active entry and update frame
> * dom0 does its work and release the frame, Xen releases the entry.
> * domu redo those steps for a new cycle.
> 
> Xen mapping process can be found in function __gnttab_map_grant_ref
> in link: http://xenbits.xen.org/hg/xen-4.1-testing.hg/file/81e39a4978ea/xen/common/grant_table.c#l2172
> 
> 
> 3. If dom0 supports grant table v2, guests run on it can either
> supports v1 or v2. Xen is responsible to judge what version the
> guests are using. This is implemented in link: http://xenbits.xen.org/hg/xen-4.1-testing.hg/file/81e39a4978ea/xen/common/grant_table.c#l2172.
> Key word is:  rd->grant_table->gt_version.
> 
> 4. Grant table2 is a precondition to netchannel2 mechanism.

Well, .. parts of netchannel2 that are going to be put in the netback
and netfront as ways of expanding the driver (add new features).

netchannel2 by itself is dead, and we can pick some of its grand ideas
from it and put them in netback/netfront.

> Netchannel2 imports a new device type: vif2. To support this type,
> we need new netback2, netfront2 driver and modification in Xen. If
> all are ready, two types of vif can be supported: vif and vif2. vif
> is for original backend and frontend, vif2 is for netback2 and
> netfront2.
> 
> Thanks
> Annie
