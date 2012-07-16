Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2GPPrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:47:32 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:9875 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751262Ab2GPPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:47:28 -0400
Message-ID: <1342453645.2523.17.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: 82571EB: Detected Hardware Unit Hang
From: Ben Hutchings <bhutchings@solarflare.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "Dave, Tushar N" <tushar.n.dave@intel.com>, Joe Jin <joe.jin@oracle.com>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 16:47:25 +0100
In-Reply-To: <20120715133510.GA5484@khazad-dum.debian.net>
References: <4FFE40A9.4060807@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA891274F02D7@ORSMSX102.amr.corp.intel.com>
	 <4FFE6BB9.4060106@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA891274F033B@ORSMSX102.amr.corp.intel.com>
	 <4FFE787B.9050201@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA891274F0ACC@ORSMSX102.amr.corp.intel.com>
	 <4FFF61BD.1060604@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA891274F11FF@ORSMSX102.amr.corp.intel.com>
	 <4FFFA532.1030208@oracle.com>
	 <061C8A8601E8EE4CA8D8FD6990CEA891274F2354@ORSMSX102.amr.corp.intel.com>
	 <20120715133510.GA5484@khazad-dum.debian.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-15 at 10:35 -0300, Henrique de Moraes Holschuh wrote:
> On Sun, 15 Jul 2012, Dave, Tushar N wrote:
> > Somehow setting max payload to 256 from BIOS does not set this value for all devices. I believe this is a BIOS bug.
> 
> And preferably, Linux should complain about it.  Since we know it is going
> to cause problems, and since we know it does happen, we should be raising a
> ruckus about it in the kernel log (and probably fixing it to min(path) while
> at it)...
> 
> Is this something that should be raised as a feature request with the
> PCI/PCIe subsystem?

The feature is there, but we ended up with:

commit 5f39e6705faade2e89d119958a8c51b9b6e2c53c
Author: Jon Mason <mason@myri.com>
Date:   Mon Oct 3 09:50:20 2011 -0500

    PCI: Disable MPS configuration by default

But you are welcome to share use of the fixup_mpss_256() quirk.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

