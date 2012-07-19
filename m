Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2GSKjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:39:47 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44390 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab2GSKjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:39:45 -0400
Message-ID: <5007E3E6.3030409@mev.co.uk>
Date: Thu, 19 Jul 2012 11:39:34 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: Ian Abbott <ian.abbott@mev.co.uk>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 32/90] staging: comedi: amplc_pc236: store the pci_dev
 in the comedi_device
References: <201207181839.24686.hartleys@visionengravers.com> <5007E1C9.1040509@mev.co.uk>
In-Reply-To: <5007E1C9.1040509@mev.co.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 11:30, Ian Abbott wrote:
> On 2012-07-19 02:39, H Hartley Sweeten wrote:
>> Use the hw_dev pointer in the comedi_device struct to hold the
>> pci_dev instead of carrying it in the private data.
>>
>> Since the pci_dev is no longer held in the provate data, we can
>> also cleanup the detach a bit. Remove the IS_ENABLED() tests in
>> the detach. If the pci_dev is non NULL it's a PCI device otherwise
>> it's an ISA device. Using IS_ENABLED() to omit the code paths
>> makes the code a bit confusing and doesn't save much.
>
> The detach() routine should really check thisboard->bustype for
> robustness, as NULL hw_dev doesn't necessarily mean its a PCI device.
> The original code should have checked thisboard->bustype too although it
> works by accident because dev->iobase is 0.

I can submit a patch to add thisboard->bustype checks in the detach 
routine after your patch is applied.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


