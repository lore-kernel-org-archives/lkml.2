Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0FBHuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:50:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0FBHuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ATbyKXTydFM6rA7U34OQX9vvkmRNi7MnS1y8eQLAHq7qFb9srX2SoTBQ1xdEmyUtED
         SX7E0KLy+KwXVbcFTGiDAyiFHrl+77KQEp4cjebfjWFr7Dnp6F7KEZt7FWJ7zxuQZi9i
         q2SWDbZL8tNDu2A49eX3iYly8Ui4/nJ7wnto8=
MIME-Version: 1.0
In-Reply-To: <4C060224.4090601@nokia.com>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	<AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	<AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
	<1275420536.28134.37.camel@localhost.localdomain>
	<4C060224.4090601@nokia.com>
Date: Wed, 2 Jun 2010 12:50:50 +0500
Message-ID: <AANLkTikuXjWTEfYG2JLNW6znGGKNxzobw3ijCpG7u1xz@mail.gmail.com>
Subject: Re: [PATCH 00/14] EVM
From: Shaz <shazalive@gmail.com>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: ext Mimi Zohar <zohar@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 12:03 PM, Dmitry Kasatkin
<dmitry.kasatkin@nokia.com> wrote:
>
>
> On 01/06/10 22:28, ext Mimi Zohar wrote:
>> On Mon, 2010-05-31 at 15:08 +0500, Shaz wrote:
>>
>>>> EVM is based on EA while Aegis does not use EA as far as I can
>>>> understand from the documentation available. Can we make EVM
>>>> independent of EA? Even the MAC mechanism is very different then
>>>> existing LSM based mechanisms.
>>>>
>>> Have a look at the following:
>>>
>>> http://research.nokia.com/files/NRCTR2008010.pdf
>>> http://research.nokia.com/files/NRCTR2008007.pdf
>>> http://lwn.net/Articles/372937/
>>>
>> SELinux, Smack, Capabilities, and IMA all use extended attributes. The
>> purpose of EVM is to detect offline tampering of these security extended
>> attributes.

MeeGo/Maemo security framework does not use LSM because Maemo/MeeGo
security framework only focuses at process level MAC and for that they
use Dazuko as Nokia research report mentions.

By the way MeeGo 1.0 has no security at the moment so one cannot be
sure if they are going according to their research or what. They are
also not opening the internals of their security framework. Not sure
why if the whole thing is open and Linux Foundation is backing it up.

>> The IMA integrity appraisal extension extends IMA with local measurement
>> appraisal. The extension stores and maintains the file integrity
>> measurement as an extended attribute 'security.ima', which EVM can be
>> configured to protect.  Instead of storing the hash measurement as an
>> extended attribute, the file hashes could be loaded in kernel memory, as
>> long as the appraise policy is appropriately constrained.
>>
>>
> Hi,
>
> Maemo integrity protection solution was based on old DigSig project
> which was used to verify
> integrity of executables. Signed integrity measurement was embedded to
> the ELF header.
> When we started to develop it EVM was not available.
>
> And we decided to use a file to keep hashes and other info.
>
> Our goals were
> 1. Protect also certain data files.
> digsig worked only with ELF files.
>
> 2. Be mobile friendly
> It seems faster to verify signature of one file with hashes instead of
> checking signature of every EA.

Here Mimi can explain better because I am of the same opinion as yours
if you mean that all signatures lie in one file and you check it from
there. Anyways some sort of policy can reduce checking every EA ... I
guess.

> 3. Persistant to offline attacks
> EA can be delete. If not all files has EA then it is not possible to
> detect removal

Availability of EA on all file systems needs some effort but it's not
a big deal. I have even seen patches for yaffs2.

> 4. Do not use EA.
> IIRC it was some problems with EA on our system and we could not use them..

This is a bad excuse :)

> EVM looks very interesting and I would like also to review the code and
> understand the architecture.
> We consider possibility to use EVM if it is going to be in the kernel.

Please do have a look because we need these features too but in a
light weight manner. We are trying to make available similar
functionality for OpenMoko based software stacks.

-- 
Shaz
