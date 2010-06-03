Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572Ab0FCCCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:02:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:6458 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518Ab0FCCCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:02:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,350,1272870000"; 
   d="scan'208";a="804288809"
Date: Thu, 3 Jun 2010 10:02:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ipconfig: document DHCP hostname and DNS record
Message-ID: <20100603020244.GB4461@localhost>
References: <20100531031953.GA10590@localhost>
 <20100602.070531.73368509.davem@davemloft.net>
 <20100602185601.GB14221@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602185601.GB14221@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:56:01AM +0800, Andi Kleen wrote:
> On Wed, Jun 02, 2010 at 07:05:31AM -0700, David Miller wrote:
> > From: Wu Fengguang <fengguang.wu@intel.com>
> > Date: Mon, 31 May 2010 11:19:53 +0800
> > 
> > > Normally dhclient can be configured to send the "host-name" option
> > > in DHCP requests to update the client's DNS record. However for an
> > > NFSROOT system, dhclient shall never be called (which may change the
> > > IP addr and therefore lose your root NFS mount connection).
> > > 
> > > So enable updating the DNS record with kernel parameter
> > > 
> > > 	ip=::::$HOST_NAME::dhcp
> > > 
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > Applied, thanks.
> 
> Small nit: Fengguang, please document the new option in 
> Documentation/kernel-parameters.txt That could be done in a follow-on patch.

Good suggestion! Here is the document update.

Thanks,
Fengguang
---
ipconfig: document DHCP hostname and DNS record

Now it's possible to update the DNS record for $HOST_NAME with

	ip=::::$HOST_NAME::dhcp

CC: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/filesystems/nfs/nfsroot.txt |    2 ++
 1 file changed, 2 insertions(+)

--- linux.orig/Documentation/filesystems/nfs/nfsroot.txt	2010-06-03 09:52:17.000000000 +0800
+++ linux/Documentation/filesystems/nfs/nfsroot.txt	2010-06-03 09:52:19.000000000 +0800
@@ -124,6 +124,8 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netm
 
   <hostname>	Name of the client. May be supplied by autoconfiguration,
   		but its absence will not trigger autoconfiguration.
+		If specified and DHCP is used, the user provided hostname will
+		be carried in the DHCP request to hopefully update DNS record.
 
   		Default: Client IP address is used in ASCII notation.
 
