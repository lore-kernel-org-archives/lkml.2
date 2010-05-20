Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0ETO0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:26:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60259 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0ETO0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:26:19 -0400
Message-ID: <4BF54689.7090106@us.ibm.com>
Date: Thu, 20 May 2010 07:26:17 -0700
From: Nivedita Singhvi <niv@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jan-Bernd Themann <THEMANN@de.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Doug Maxey <doug.maxey@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       dvhltc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, michael@ellerman.id.au,
       niv@linux.vnet.ibm.com, Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com> <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com> <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain> <alpine.LFD.2.00.1005192244430.3368@localhost.localdomain> <1274319248.22892.40.camel@concordia> <OF17F8F35C.B09E4797-ONC1257729.0028292D-C1257729.0029E9AC@de.ibm.com> <alpine.LFD.2.00.1005200950410.3368@localhost.localdomain> <OFCBBE5EB9.FD616EDA-ONC1257729.0030B539-C1257729.0031FB06@de.ibm.com> <alpine.LFD.2.00.1005201112000.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005201112000.3368@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

>> Pleaes check if multiple queues are enabled. The following module parameter
>> is used for that:
>>
>> MODULE_PARM_DESC(use_mcs, " 0:NAPI, 1:Multiple receive queues, Default = 0
>> ");
>>
>> you should also see the number of used HEA interrupts in /proc/interrupts
> 
> I leave that for Will and Darren, they have the hardware :)

  16:     477477	...	XICS      Level     IPI
  17:        129 ...	XICS      Level     hvc_console
  18:          0 ...	XICS      Level     RAS_EPOW
  33:     139232 ...     XICS      Level     mlx4_core
256:          3 ...     XICS      Level     ehea_neq
259:          0 ...     XICS      Level     eth0-aff
260:    2082153 ...	XICS      Level     eth0-queue0
289:     119166 ...	XICS      Level     ipr
305:          0 ...	XICS      Level     ohci_hcd:usb2
306:          0 ...	XICS      Level     ohci_hcd:usb3
307:    2389839 ...	XICS      Level     ehci_hcd:usb1


Nope, multiple rx queues not enabled.

thanks,
Nivedita
