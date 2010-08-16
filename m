Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0HPDbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 23:31:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63812 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0HPDbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 23:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cMaobP9IKE7LehzovhzoTFZz/CYF+nqwMHak50F42PoBAvITEvAwuG3XpM00M3oGsr
         APSFOhP9yIudZN6yHJ443AdEpwPzQ4FjYbhTO1hAcUE1jOW/CC2t5n3o2crvj4W58vdI
         zucMPAAujmlsZFp2hnb7Ac/cV8DxNv2XzMQ2Q=
Message-ID: <4C68B111.9090302@gmail.com>
Date: Sun, 15 Aug 2010 21:31:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Evan Lavelle <sa212+lkml@cyconix.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
References: <4C5002AD.6070206@cyconix.com> <4C66B580.5060606@cyconix.com>
In-Reply-To: <4C66B580.5060606@cyconix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2010 09:25 AM, Evan Lavelle wrote:
> Thanks guys. I had to get this working quickly so I just stuck with my
> bounce buffer code. I'm not sure that it's technically a 'bounce
> buffer'; it just so happens that 'pci_alloc_consistent' returns an
> address in the low 32 bits. This may stop working if the user installs
> more than 4Gig of memory but I can live with that for now. Performance

That should be safe as far as x86-32 goes - pci_alloc_consistent will 
return a low memory address which will be below 1GB.

> isn't great (~110Mbytes/s on 4-channel PCIe) but it's good enough.
>
> It's disappointing that LDD didn't have anything to say about this; it's
> pretty fundamental to DMA on x86_32 and PAE.

The situation kind of sucks with that combination, yes. The block and 
network subsystems have their own workarounds but other drivers just 
have to sort of hack something together.
