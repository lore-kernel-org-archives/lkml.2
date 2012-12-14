Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2LNJdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:33:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2LNJdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:33:11 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage devices and support new switch command
Date: Fri, 14 Dec 2012 10:33:39 +0100
Message-ID: <1758237.OLMhWhauCd@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8-12-desktop+; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121214093141.7e4eba61@pyramind.ukuu.org.uk>
References: <fe8c905bb12.b12fe8c905b@huawei.com> <910F9D9E13B84F4C8FA771DC9BDE99F326FBFB54@szxeml546-mbs.china.huawei.com> <20121214093141.7e4eba61@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2012 09:31:41 Alan Cox wrote:
> On Fri, 14 Dec 2012 03:01:24 +0000
> "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> wrote:
> 
> > Dear Alan:
> > 
> > 	This prevents people getting access to the storage device if they want.
> > 	----In our device, after its switching, it will keep the cdrom port together with other ports (such as modem port). So you can access the storage device too, after our switch.
> 
> Ok so the behaviour is
> 
> 	plug in device
> 	"I am a CD-ROM"
> 	command sent
> 	"I am a CD-ROM, I am a modem, I am other things"
> 
> with the newer devices ?

For such devices we should put the switching code into generic code,
not a device driver so that we have a chance to do reset_resume()
on those devices.

	Regards
		Oliver

