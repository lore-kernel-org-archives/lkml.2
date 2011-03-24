Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302Ab1CXUyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:54:11 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:51614 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab1CXUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:54:04 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.34
X-Originating-IP: 173.50.155.44
Message-ID: <4D8BAF4F.30609@pbjtriplett.org>
Date: Thu, 24 Mar 2011 13:53:35 -0700
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: linux-kernel@vger.kernel.org
Subject: Re: BITS handling of CPU microcode updates
References: <4D65EE74.1050709@pbjtriplett.org> <20110312023001.GB27550@khazad-dum.debian.net> <4D87E2CD.6020306@pbjtriplett.org> <20110324001451.GA7950@khazad-dum.debian.net>
In-Reply-To: <20110324001451.GA7950@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 05:14 PM, Henrique de Moraes Holschuh wrote:
> On Mon, 21 Mar 2011, Burt Triplett wrote:
>> The Intel SDM correctly identifies microcode revision numbers as
>> signed.  However, a simple signed comparison doesn't actually
>> capture the correct logic, nor does an unsigned comparison, though
>> in both cases the problem doesn't tend to come up in common cases.
>
> ...
>
>> Tools which run automatically, without explicit user action, should
>> not attempt to load a microcode if (X<  0) and (Z>  0).  Doing so
>> makes life very difficult for people in those test lab environments:
>> they put a microcode they want to test in the BIOS or load it via
>> BITS, but then the OS driver automatically overrides it with the
>> latest production microcode.  So, tools which run automatically
>> without explicit user action should follow this rule:
>> if ((Z < 0) || (Z > 0 && X > 0 && Z > X)) load_microcode();
>
> Very well, I will send patches to fix that behaviour, as well as some
> other stuff I noticed that was not updated to match the recommended
> actions documented by the SDM and some Intel application notes.

Thanks!

Out of curiosity, which other discrepancies did you encounter?

Also, please CC me on the patch, and I'll review the changes.

>> If microcode_ctl added an option to distinguish these two cases, it
>> could apply the alternative logic when explicitly requested.
>
> Indeed, the userspace and internal kernel API don't support that at this
> time.
>
> Now, we could change them I suppose, but it doesn't look like a worthwhile
> effort to change the microcode core and APIs for something that would be
> of limited use even inside an Intel lab.

Agreed; in general such microcode will get loaded before booting Linux, 
not via the Linux microcode driver.

> Unless there is a reason to support online microcode downgrading, that is.
> Does it?  Currently, the rare case of a microcode downgrade will only
> happen at the next boot.

No, the driver doesn't need to support this case.

- Burt Triplett
