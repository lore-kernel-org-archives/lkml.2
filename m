Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0FBHD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:03:28 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51195 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab0FBHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:03:26 -0400
Message-ID: <4C060224.4090601@nokia.com>
Date: Wed, 02 Jun 2010 10:03:00 +0300
From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: ext Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Shaz <shazalive@gmail.com>, James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Subject: Re: [PATCH 00/14] EVM
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>	 <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>	 <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>	 <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com> <1275420536.28134.37.camel@localhost.localdomain>
In-Reply-To: <1275420536.28134.37.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2010 07:02:58.0107 (UTC) FILETIME=[A1BFD0B0:01CB0221]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/06/10 22:28, ext Mimi Zohar wrote:
> On Mon, 2010-05-31 at 15:08 +0500, Shaz wrote:
>   
>>> EVM is based on EA while Aegis does not use EA as far as I can
>>> understand from the documentation available. Can we make EVM
>>> independent of EA? Even the MAC mechanism is very different then
>>> existing LSM based mechanisms.
>>>       
>> Have a look at the following:
>>
>> http://research.nokia.com/files/NRCTR2008010.pdf
>> http://research.nokia.com/files/NRCTR2008007.pdf
>> http://lwn.net/Articles/372937/
>>     
> SELinux, Smack, Capabilities, and IMA all use extended attributes. The
> purpose of EVM is to detect offline tampering of these security extended
> attributes.
>
> The IMA integrity appraisal extension extends IMA with local measurement
> appraisal. The extension stores and maintains the file integrity
> measurement as an extended attribute 'security.ima', which EVM can be
> configured to protect.  Instead of storing the hash measurement as an
> extended attribute, the file hashes could be loaded in kernel memory, as
> long as the appraise policy is appropriately constrained.
>
>   
Hi,

Maemo integrity protection solution was based on old DigSig project
which was used to verify
integrity of executables. Signed integrity measurement was embedded to
the ELF header.
When we started to develop it EVM was not available.

And we decided to use a file to keep hashes and other info.

Our goals were
1. Protect also certain data files.
digsig worked only with ELF files.

2. Be mobile friendly
It seems faster to verify signature of one file with hashes instead of
checking signature of every EA.

3. Persistant to offline attacks
EA can be delete. If not all files has EA then it is not possible to
detect removal

4. Do not use EA.
IIRC it was some problems with EA on our system and we could not use them..


EVM looks very interesting and I would like also to review the code and
understand the architecture.
We consider possibility to use EVM if it is going to be in the kernel.

- Dmitry Kasatkin
Maemo/MeeGo security team

> Mimi
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
