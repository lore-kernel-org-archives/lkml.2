Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2GSKlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:41:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44396 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2GSKlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:41:46 -0400
Message-ID: <5007E454.8020302@mev.co.uk>
Date: Thu, 19 Jul 2012 11:41:24 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 34/90] staging: comedi: amplc_pc263: store the pci_dev
 in the comedi_device
References: <201207181840.01906.hartleys@visionengravers.com>
In-Reply-To: <201207181840.01906.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 02:40, H Hartley Sweeten wrote:
> Use the hw_dev pointer in the comedi_device struct to hold the
> pci_dev instead of carrying it in the private data.
>
> Since the pci_dev is no longer held in the provate data, we can
> also cleanup the detach a bit. Remove the IS_ENABLED() tests in
> the detach. If the pci_dev is non NULL it's a PCI device otherwise
> it's an ISA device. Using IS_ENABLED() to omit the code paths
> makes the code a bit confusing and doesn't save much.
>
> Since the pci_dev was the only thing in the private data, remove
> the struct, and it's allocation.

As mentioned for amplc_dio200 and amplc_pc236, the detach() routine 
ought to check thisboard->bustype although the original code and the 
patched version should work fine as dev->iobase will be 0 on failure.

I'll submit a patch later to check thisboard->bustype in the detach() 
routine for robustness.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


