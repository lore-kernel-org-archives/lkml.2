Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2GSK1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:27:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44352 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2GSK11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:27:27 -0400
Message-ID: <5007E0FE.4030602@mev.co.uk>
Date: Thu, 19 Jul 2012 11:27:10 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: Ian Abbott <ian.abbott@mev.co.uk>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 30/90] staging: comedi: amplc_dio200: store the pci_dev
 in the comedi_device
References: <201207181837.50650.hartleys@visionengravers.com> <5007DD1F.4040703@mev.co.uk>
In-Reply-To: <5007DD1F.4040703@mev.co.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 11:10, Ian Abbott wrote:
> On 2012-07-19 02:37, H Hartley Sweeten wrote:
>> Use the hw_dev pointer in the comedi_device struct to hold the
>> pci_dev instead of carrying it in the private data.
>>
>> Since the pci_dev is no longer held in the provate data, we can
>> also cleanup the detach a bit. Remove the IS_ENABLED() tests in
>> the detach. If the pci_dev is non NULL it's a PCI device otherwise
>> it's an ISA device. Using IS_ENABLED() to omit the code paths
>> makes the code a bit confusing and doesn't save much.
>
> No, you really need to check thisboard->bustype in the detach() because
> hw_dev might be NULL for a PCI board if the attach() failed.

Actually, your patch wouldn't do any harm as dev->iobase would be 0.  It 
would just go through the "failed ISA device" path instead of the 
"failed PCI device" path.  It would be more robust to check 
thisboard->bustype though.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


