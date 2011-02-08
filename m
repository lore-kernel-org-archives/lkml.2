Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1BHJzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:55:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1BHJzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:55:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gep/sbL7UnypKswv77mAv6uB1vHcf+Q9EzJQGZxf3SEJ6DQkGHxU9NwCqSMfC/XYc5
         BhSGJfWtA6CoH+wfxCkABhp0d8A5ZZp1tb7T2o1jF2/qFfCE45NjOYCUBlhhbJqDtlEg
         SZnZX47fUqqsuxc9T6yk2vAulTcS2TZUy6dwg=
Message-ID: <4D5112F5.8030700@gmail.com>
Date: Tue, 08 Feb 2011 10:55:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz> <AANLkTinN40GMRL3bJ7LKDmhCYK1AYZfQ+mVYwxDP1ZQe@mail.gmail.com> <4D3025F4.6020001@gmail.com> <201101140910.07154.bjorn.helgaas@hp.com>
In-Reply-To: <201101140910.07154.bjorn.helgaas@hp.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 05:10 PM, Bjorn Helgaas wrote:
> On Friday, January 14, 2011 03:31:16 am Jiri Slaby wrote:
>> On 01/14/2011 01:15 AM, Linus Torvalds wrote:
>>> On Thu, Jan 13, 2011 at 3:19 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>>>
>>>> I think we're back to the question of why we have the ICH4 quirk in
>>>> the first place, and I don't know the answer to that.
>>>
>>> Iirc, there were several laptops that didn't have the ACPI region
>>> mentioned in any of the regular places, and we'd allocate the PCMCIA
>>> IO region on top of them. The machine would boot, but if anybody ever
>>> inserted a PCCard into the machine, the first access to the IO region
>>> would generally just halt it (because it was trying to read the
>>> PCCard, but the APCI region decodes first, and then the read from that
>>> usually put the CPU in a sleep state that it would never wake up from
>>> for obvious reasons).
>>>
>>> So we do want the ICH4 quirk.
>>
>> Yes, this is an "official" way how ICH4 (and later) advertises the region.
> 
> The quirk is a bug workaround, *not* the "official, planned" way to
> deal with these regions.  The official way is to use ACPI, because
> that's a generic way that doesn't require changes for new versions
> of ICH.

Ok, I understand that. For non-ACPI setups this is probably the only
place to look at.

Anyway, has anybody had a chance to look at the patches? Any comments,
nacks/acks?

https://lkml.org/lkml/2011/1/14/115
https://lkml.org/lkml/2011/1/14/113
https://lkml.org/lkml/2011/1/14/114

thanks,
-- 
js
