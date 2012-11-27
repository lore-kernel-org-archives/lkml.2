Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2K0SKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:10:45 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:10857 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2K0SKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:10:44 -0500
Message-ID: <1354039840.2701.14.camel@bwh-desktop.uk.solarflarecom.com>
Subject: RE: [E1000-devel] 82571EB: Detected Hardware Unit Hang
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Fujinaka, Todd" <todd.fujinaka@intel.com>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
CC: Joe Jin <joe.jin@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Tue, 27 Nov 2012 18:10:40 +0000
In-Reply-To: <9B4A1B1917080E46B64F07F2989DADD62F2D8070@ORSMSX102.amr.corp.intel.com>
References: <509B5038.8090304@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
	 <50A30656.6090508@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com>
	 <50A43828.6000702@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA8913349A0B4@ORSMSX102.amr.corp.intel.com>
	 <50A9C5CC.1030300@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA8913349EB41@ORSMSX102.amr.corp.intel.com>
	 <50AB8471.7080607@oracle.com>
	 <9B4A1B1917080E46B64F07F2989DADD62F2D62D6@ORSMSX102.amr.corp.intel.com>
	 <50B41077.3080009@oracle.com>
	 <b46b84cf-3688-4fd7-b741-4e96f2663517@default>
	 <9B4A1B1917080E46B64F07F2989DADD62F2D8070@ORSMSX102.amr.corp.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 17:32 +0000, Fujinaka, Todd wrote:
> Forgive me if I'm being too repetitious as I think some of this has
> been mentioned in the past.
> 
> We (and by we I mean the Ethernet part and driver) can only change the
> advertised availability of a larger MaxPayloadSize. The size is
> negotiated by both sides of the link when the link is established. The
> driver should not change the size of the link as it would be poking at
> registers outside of its scope and is controlled by the upstream
> bridge (not us).
[...]

MaxPayloadSize (MPS) is not negotiated between devices but is programmed
by the system firmware (at least for devices present at boot - the
kernel may be responsible in case of hotplug).  You can use the kernel
parameter 'pci=pcie_bus_perf' (or one of several others) to set a policy
that overrides this, but no policy will allow setting MPS above the
device's MaxPayloadSizeSupported (MPSS).

(These parameters are not documented in
Documentation/kernel-parameters.txt!  Someone ought to fix that.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

