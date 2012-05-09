Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2EIQCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:02:12 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:50847 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab2EIQCK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Wed, 9 May 2012 12:02:10 -0400
Message-Id: <4FAAB134020000780008294F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 17:02:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/5, resend] PCI: adjust quirk handler section
 annotations
References: <4FAA4A5A0200007800082702@nat28.tlf.novell.com>
 <CAErSpo68N5JYv_SX7Qzu4e0Z=x_g1U+FPaA-ux_W_zoB6iW+pw@mail.gmail.com>
In-Reply-To: <CAErSpo68N5JYv_SX7Qzu4e0Z=x_g1U+FPaA-ux_W_zoB6iW+pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.05.12 at 17:54, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, May 9, 2012 at 1:43 AM, Jan Beulich <JBeulich@suse.com> wrote:
>> This is in preparation to adjust modpost to check section mismatches
>> on most of the .pci_fixup* sections:
>>
>> .pci_fixup_final is only used from .init.text, and hence can (along
>> with the respective handler functions) reside in .init.*.
> 
> pci_apply_final_quirks() is currently __init, so this probably
> wouldn't break anything.   But the fact that it's all __init means
> that pci_fixup_final quirks are only run for devices present at boot,
> and they don't apply to hot-added devices.  That seems like a bug to
> me.
> 
>> Several other .pci_fixup_* sections are needed only during boot and
>> suspend/resume, and can therefore be moved into .init.* if
>> !CONFIG_PM.
> 
> My inclination is that all PCI fixups should work the same for
> hot-added devices as for those present at boot, which would suggest
> that we should always use __devinit, not __init.  If I'm missing
> something, please educate me :)

That's certainly possible - I simply based the patch on what is there
currently.

Jan

