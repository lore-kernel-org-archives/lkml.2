Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2DMRCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:02:52 -0400
Received: from mail.solarflare.com ([216.237.3.220]:12245 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754265Ab2DMRCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:02:50 -0400
Message-ID: <1334336563.2606.3.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 12/37] atl1c: restore max-read-request-size in Device
 Conrol Register
From: Ben Hutchings <bhutchings@solarflare.com>
To: xiong <xiong@qca.qualcomm.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qca-linux-team@qualcomm.com>,
        <nic-devel@qualcomm.com>, linux-pci <linux-pci@vger.kernel.org>
Date: Fri, 13 Apr 2012 18:02:43 +0100
In-Reply-To: <1334276102-15866-13-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
	 <1334276102-15866-13-git-send-email-xiong@qca.qualcomm.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18834.005
X-TM-AS-Result: No--14.516400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 08:14 +0800, xiong wrote:
> in some platforms, we found the max-read-request-size in Device Control
> Register is set to 0 by (BIOS?) during bootup, this will cause the
> performance(throughput) very bad.
> Restore it to a min-value.
> register definition of REG_DEVICE_CTRL is refined as well.
[...]

I'm guessing this memory-mapped register is an alias for the PCIe device
control register.  I think you should be using pcie_set_readrq() to
ensure that the final setting conforms to the device's Max Payload Size
and system policy.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

