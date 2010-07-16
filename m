Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935133Ab0GPAvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:51:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57202 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934682Ab0GPAvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:51:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cuzUjFhnOrtjx/RW8K1FhbExZW1VeK31AC+WdPyrcxNoXut0Es8VPEVlKMTo2Ma4z3
         vGhUcn6oMydN5IJMy8L23gLhr2BMv2dmNh7id+TJSd5LonxvspaYqQ7eGm7JVVFNkJG7
         x2538VLH8/9x2Fq3YVaS+Cb8DrzBngvounc2M=
Message-ID: <4C3FAD07.6040104@garzik.org>
Date: Thu, 15 Jul 2010 20:51:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Peter Huewe <PeterHuewe@gmx.de>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/25] block: Convert pci_table entries to PCI_VDEVICE
 (if PCI_ANY_ID is used)
References: <201007152051.18189.PeterHuewe@gmx.de> <20100715185904.GA4023@x200>
In-Reply-To: <20100715185904.GA4023@x200>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 03:03 PM, Alexey Dobriyan wrote:
> On Thu, Jul 15, 2010 at 08:51:17PM +0200, Peter Huewe wrote:
>> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
>> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
>> PCI_VDEVICE macro, and thus improves readability.
>
> Well, it doesn't improve readability, and ## usage prevents grepping and
> long term plan to switch to numbers instead of PCI_VENDOR_ID_*,
> but whatever.
>
>> -	{ PCI_VENDOR_ID_PROMISE, 0x8000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
>> -	{ PCI_VENDOR_ID_PROMISE, 0x8002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
>> +	{ PCI_VDEVICE(PROMISE, 0x8000), },
>> +	{ PCI_VDEVICE(PROMISE, 0x8002), },

Switching to use hex numbers for _device ids_ is encouraged, because 
history has proven its pointless to create named constants for 
single-use ids.  However, using named constants for PCI vendor ids makes 
a lot of sense.

	Jeff




