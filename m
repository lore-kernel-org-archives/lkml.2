Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab2GLJCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:02:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35180 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960Ab2GLJCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:02:34 -0400
Message-ID: <4FFE92A6.2070106@mev.co.uk>
Date: Thu, 12 Jul 2012 10:02:30 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/30] staging: comedi: move 'struct pci_dev *' into comedi_device
References: <201207111447.47402.hartleys@visionengravers.com> <4FFE9102.2090204@mev.co.uk> <20120712100213.4be0e50f@pyramind.ukuu.org.uk>
In-Reply-To: <20120712100213.4be0e50f@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/07/12 10:02 AM, Alan Cox wrote:
>> I suppose at a later date we could turn that into a union with a short
>> name like u (so comedidev->pcidev would become something like
>> comedidev->u.pcidev), which would allow us to stick a 'struct
>> usb_interface *' or some other hardware device wrapper struct pointer in
>> the same hole.  (Maybe 'h' for 'hardware' would be better than 'u'.)
> 
> The "usual" pattern is to make it a struct device pointer. Then you can
> get to any other kind of device from it.

You mean with container_of(), right?  Actually, 'struct comedi_device'
already has a little-used 'struct device *hw_dev' member that could be
used for this purpose.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
