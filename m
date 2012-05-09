Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab2EIQJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:09:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53620 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab2EIQJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <4FAAB134020000780008294F@nat28.tlf.novell.com>
References: <4FAA4A5A0200007800082702@nat28.tlf.novell.com>
 <CAErSpo68N5JYv_SX7Qzu4e0Z=x_g1U+FPaA-ux_W_zoB6iW+pw@mail.gmail.com> <4FAAB134020000780008294F@nat28.tlf.novell.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 May 2012 09:08:41 -0700
Message-ID: <CAErSpo5Aidio0a6SjeYu=-9gXJU1aALMi5mUjg2aEB5pTsr8=Q@mail.gmail.com>
Subject: Re: [PATCH 1/5, resend] PCI: adjust quirk handler section annotations
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 9:02 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 09.05.12 at 17:54, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Wed, May 9, 2012 at 1:43 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>> This is in preparation to adjust modpost to check section mismatches
>>> on most of the .pci_fixup* sections:
>>>
>>> .pci_fixup_final is only used from .init.text, and hence can (along
>>> with the respective handler functions) reside in .init.*.
>>
>> pci_apply_final_quirks() is currently __init, so this probably
>> wouldn't break anything.   But the fact that it's all __init means
>> that pci_fixup_final quirks are only run for devices present at boot,
>> and they don't apply to hot-added devices.  That seems like a bug to
>> me.
>>
>>> Several other .pci_fixup_* sections are needed only during boot and
>>> suspend/resume, and can therefore be moved into .init.* if
>>> !CONFIG_PM.
>>
>> My inclination is that all PCI fixups should work the same for
>> hot-added devices as for those present at boot, which would suggest
>> that we should always use __devinit, not __init.  If I'm missing
>> something, please educate me :)
>
> That's certainly possible - I simply based the patch on what is there
> currently.

Yep, your patch makes perfect sense considering the tree as it is
today.  But if you agree with my sense of what it *should* be, I think
we should leave things as they are, or work on moving everything
towards __devinit (I'd be thrilled if you wanted to work on that :)).
Otherwise we'd just be changing things to __init that we'd have to
change back later.

Bjorn
