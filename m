Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab2GLIzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:55:40 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35143 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2GLIzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:55:37 -0400
Message-ID: <4FFE9102.2090204@mev.co.uk>
Date: Thu, 12 Jul 2012 09:55:30 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/30] staging: comedi: move 'struct pci_dev *' into comedi_device
References: <201207111447.47402.hartleys@visionengravers.com>
In-Reply-To: <201207111447.47402.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/07/11 10:47 PM, H Hartley Sweeten wrote:
> All the comedi pci drivers have a struct pci_dev * in their private
> data to hold the pointer to the pci device. Some of the drivers only
> have private data because of this pointer.
> 
> Move the variable into the comedi_device struct and remove the private
> data for the drivers that no longer need it.

I suppose at a later date we could turn that into a union with a short
name like u (so comedidev->pcidev would become something like
comedidev->u.pcidev), which would allow us to stick a 'struct
usb_interface *' or some other hardware device wrapper struct pointer in
the same hole.  (Maybe 'h' for 'hardware' would be better than 'u'.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
