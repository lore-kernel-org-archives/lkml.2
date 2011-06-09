Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1FITrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:47:25 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:24001
	"EHLO CH1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754654Ab1FITrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:47:23 -0400
X-SpamScore: -11
X-BigFish: VS-11(zz168aJ1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF12345.1040409@freescale.com>
Date: Thu, 9 Jun 2011 14:47:17 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: <alan@lxorguk.ukuu.org.uk>, <arnd@arndb.de>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <cmetcalf@tilera.com>, <konrad.wilk@oracle.com>, <dsaxena@linaro.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307646794-26374-1-git-send-email-timur@freescale.com> <20110609124010.6335559e.randy.dunlap@oracle.com>
In-Reply-To: <20110609124010.6335559e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>> > +enum fsl_hv_ioctl_cmd {
>> > +	FSL_HV_IOCTL_PARTITION_RESTART = _IOWR(0, 1, struct fsl_hv_ioctl_restart),
>> > +	FSL_HV_IOCTL_PARTITION_GET_STATUS = _IOWR(0, 2, struct fsl_hv_ioctl_status),
>> > +	FSL_HV_IOCTL_PARTITION_START = _IOWR(0, 3, struct fsl_hv_ioctl_start),
>> > +	FSL_HV_IOCTL_PARTITION_STOP = _IOWR(0, 4, struct fsl_hv_ioctl_stop),
>> > +	FSL_HV_IOCTL_MEMCPY = _IOWR(0, 5, struct fsl_hv_ioctl_memcpy),
>> > +	FSL_HV_IOCTL_DOORBELL = _IOWR(0, 6, struct fsl_hv_ioctl_doorbell),
>> > +	FSL_HV_IOCTL_GETPROP = _IOWR(0, 7, struct fsl_hv_ioctl_prop),
>> > +	FSL_HV_IOCTL_SETPROP = _IOWR(0, 8, struct fsl_hv_ioctl_prop),
>> > +};

> Missing an entry in Documentation/ioctl/ioctl-number.txt for 0 (with conflict!).

If I change it from 0, I'm going to break binary compatibility with our apps.  I
agree that maybe I shouldn't have picked 0, but considering how many conflicts
there already are, I wonder what the point is.  Even if I pick a number that is
currently not listed in the chart, that doesn't mean that it's actually not
being used, or that it won't conflict in the future.

So is it okay to stick with 0, or do I need to pick a new number?

-- 
Timur Tabi
Linux kernel developer at Freescale

