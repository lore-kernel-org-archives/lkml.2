Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2BGKXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:23:19 -0500
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:36819 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2BGKXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:23:18 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Feb 2012 05:23:18 EST
Message-ID: <4F30FABF.4060409@ladisch.de>
Date: Tue, 07 Feb 2012 11:19:43 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.2.5
References: <20120206181622.GA28811@kroah.com> <20120207084037.GA6140@citd.de>
In-Reply-To: <20120207084037.GA6140@citd.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer wrote:
> On 06.02.2012 10:16, Greg KH wrote:
>> I'm announcing the release of the 3.2.5 kernel.
>>
>> It contains one PCI patch, it is up to you to decide to upgrade or not.
>
> This one makes my Soundblaster Live (alsa/emu10k1) silent.
> It is detected, i can e.g. change the mixer, but i can't hear any sound.

Back in the PCI days, the Emu10k1 chip was known to be quite inefficient
(many small transfers, and IIRC even latency timer bugs) and to be
problematic when used with other high-bandwidth PCI chips like TV capture
cards.

> There is a difference in syslog output regarding aspm, the emu10k1 line
> is the same.

Your PCIe/PCI bridge (5:0.0, iTE IT8892) which handles the PCI bus is
affected by the change.

I do not know if this is an actual hardware bug, or if the bridge is
just too slow to wake up the PCIe link.

Please show the output of "lspci -v -s 5:0".

> pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'

Does this mean that the new kernel _dis_ables ASPM, where it left it
enabled previously?

Please try that kernel parameter.


Regards,
Clemens
