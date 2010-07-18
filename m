Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab0GRWot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 18:44:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61166 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab0GRWos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 18:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TOugahUSIYc96Nz2vyMwvvFnRTcJrealHPj7HiMlXtyrKW79q/JgaRyRzEuc/5hEnk
         1Hfy4l+7I7+vcfCOE87bjLcykegReT3u3DtOop5H3d9QhY8d68XI6JjI2t7SfQxVRZin
         I4Qf0eKDNMt86o9laLjWZ1ECqUv6zN6nVgilE=
Message-ID: <4C4383D9.3060705@pobox.com>
Date: Sun, 18 Jul 2010 18:44:41 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH[RFC] Quirk macbook pro 6,2 into ahci mode
References: <4C4325E0.5020407@fusionio.com> <20100718184243.GA4062@srcf.ucam.org>
In-Reply-To: <20100718184243.GA4062@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 02:42 PM, Matthew Garrett wrote:
> On Sun, Jul 18, 2010 at 10:03:44AM -0600, Jens Axboe wrote:
>> Looking at the specs, I don't see what I am missing to make this
>> work for resume. I'm assuming that EFI did initialize some bits
>> that am missing when coming out of resume, but I don't know which
>> bits.
>
> There's no guarantee that the AHCI BAR is programmed by the firmware (it
> seems to be on the Macs, but won't be on most hardware). Is it getting
> reprogrammed on resume?

That's definitely the key question.

I would have quirked AHCI/piix hardware into AHCI mode long ago, if 
firmwares defaulting to piix mode would actually program the PCI BAR 
correctly.

Or, if the firmware had some way to safely allocate a bus memory range, 
which we could ourselves program into the PCI BAR.  Some non-PC 
platforms can do that.

	Jeff


