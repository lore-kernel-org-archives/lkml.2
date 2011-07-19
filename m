Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1GSNxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:53:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1GSNxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:53:01 -0400
Message-ID: <4E258C2D.2070808@redhat.com>
Date: Tue, 19 Jul 2011 09:52:45 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/34] System Firmware Interface
References: <1310994528-26276-1-git-send-email-prarit@redhat.com> <1310994528-26276-2-git-send-email-prarit@redhat.com> <m2vcuz3xsz.fsf@firstfloor.org> <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk> <4E25775A.4050306@redhat.com> <20110719132531.GH8006@one.firstfloor.org>
In-Reply-To: <20110719132531.GH8006@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/19/2011 09:25 AM, Andi Kleen wrote:
> Playing the devils advocate here, but this is really unclear...
>
>   

Sorry, I'll try to be more specific.

>> There is some additional information I'd like to throw out here as
>> well.  SMBIOS also provides information on the system state after the
>> BIOS/EFI is finished and before the kernel has been booted.  This has
>> been *invaluable* to me when diagnosing some wonky hardware from OEMs. 
>>     
> Hmm this is for SMBIOS tables that changes at runtime?
> Why exactly is the kernel booting a good point to dump that?
>
>   

Let me back up :) as I clearly didn't do a good job of explaining this.

I have systems/have had systems in which NO kernel would boot because of
faulty hardware.  That hardware was identified as bad during the BIOS
POST but no information on it could be determined because we didn't make
it very far through boot :/.  As you know Andi, booting with bad memory
or a bad cpu is excruciatingly difficult to diagnose.

The SMBIOS does provide access to a system log in which details on
failed hardware (again, failed hardware having been identified by the
BIOS) and that information was immensely useful to me during the system
boot.  (see the Type 15 System Event Log Structure).

Plugging that into the existing "dmi" code was a headache.  The code is
just not laid out to make expansion of dmi devices easy.

>   
>> I want to expand the SMBIOS layer to dump that information out when I
>>     
> What information exactly?
>
> And dumping = print to system log?
>   

Yes, to the system log.

>   
>> tl;dr: There are some other useful bits of SMBIOS we could take
>> advantage of but the current "dmi" layer is difficult to work with.
>>     
> Like what?
>
>   

Like the above example ;) ... but there are other things like the type
of memory in the system from a HW debug point of view become important. 
My #1 goal is to get the SMBIOS version # exported via sysfs and to get
the type 15 stuff output as debug info.

P.

> -Andi
>
>   
