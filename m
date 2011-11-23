Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab1KWBth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:49:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1KWBtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:49:36 -0500
Message-ID: <4ECC512D.2010002@gmail.com>
Date: Tue, 22 Nov 2011 19:49:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: michael@alpha-unix.de, linux-kernel@vger.kernel.org
Subject: Re: Kernelpanic on eeePC and MSI Wind (both using rt2800pci) with
 Linux 3.x
References: <j978hu$i23$1@dough.gmane.org> <j9o412$oum$1@dough.gmane.org> <jah1te$h33$1@dough.gmane.org> <20111122.155557.1954460980055957565.davem@davemloft.net>
In-Reply-To: <20111122.155557.1954460980055957565.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 02:55 PM, David Miller wrote:
> From: Michael Basse<michael@alpha-unix.de>
> Date: Tue, 22 Nov 2011 21:49:49 +0100
>
>> Hi,
>>
>> just for the record. This thread is hopefully providing a patch
>>
>> http://thread.gmane.org/gmane.linux.kernel.wireless.general/80759
>>
>> already built the kernel and doing some testing now.
>
> That patch is wrong, it returns IRQ_HANDLED when it can't tell if the
> chip generated the interrupt or not.
>
> Therefore, if any other device shares that interrupt line it's
> interrupts can be lost when this case triggers.
>
> This has to be fixed another way.

Huh? IRQ_HANDLED is the "safe" return value when you don't know for sure 
whether your device generated the interrupt. Returning that doesn't 
prevent other handlers on the same IRQ from being called.
