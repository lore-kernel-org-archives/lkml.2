Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab1HJN0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:26:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab1HJN0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:26:49 -0400
Message-ID: <4E428706.3050002@redhat.com>
Date: Wed, 10 Aug 2011 09:26:30 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [lm-sensors] [PATCH 01/34] System Firmware Interface
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>	<1310994528-26276-2-git-send-email-prarit@redhat.com> <20110725210321.1e2f252e@endymion.delvare>
In-Reply-To: <20110725210321.1e2f252e@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/25/2011 03:03 PM, Jean Delvare wrote:
> On Mon, 18 Jul 2011 09:08:15 -0400, Prarit Bhargava wrote:
>   
>> This patch introduces a general System Firmware interface to the kernel, called
>> sysfw.
>>
>> Inlcluded in this interface is the ability to search a standard set of fields,
>> sysfw_lookup().  The fields are currently based upon the x86 and ia64 SMBIOS
>> fields but exapandable to fields that other arches may introduce.  Also
>> included is  the ability to search and match against those fields, and run
>> a callback function against the matches, sysfw_callback().
>>
>> Modify module code to use sysfw instead of old DMI interface.
>>     
> This is a HUGE patch set. You'd need to have a good reason for such a
> big and intrusive change, yet I see no such reason explained. I
> understand that we _can_ abstract system information interfaces, but
> just because we can doesn't mean we have to. I would at least wait for
> a second DMI-like interface to be widely implemented and support before
> any attempt to abstract, otherwise your design is bound to be missing
> the target. And even then, you'd still need to convince me that there
> is a need for a unified interface to access both backends at once. I
> would guess that you know what backend is present on a system when you
> try to identify it.
>   

It seems to me that the objection to this patchset isn't that I'm
rewriting the SMBIOS code, but that I'm adding in an additional
abstraction layer to the kernel which as Jean points out, probably isn't
going to be correct as it is based on the two Intel arches (x86 and ia64).

After discussing this with a few engineers in the office I'm leaning
toward dropping the System Firmware Interface *for now*.  I'm more than
willing to implement the SMBIOS code in such a way that it should be
easier to implement a generic interface at a later date -- I'm still
hoping that arm/arm64 will eventually need this interface but they're
realistically a year or two out from requiring such a thing.

Alan -- I know you wanted this, and there is merit in doing it but I
can't argue with what Jean wrote.  Right now we don't have an extensive
need for the sysfw stuff in the kernel ...

P.

