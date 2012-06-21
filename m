Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab2FUOUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:20:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48035 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2FUOUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:20:05 -0400
MIME-Version: 1.0
In-Reply-To: <4FE3040B020000780008B030@nat28.tlf.novell.com>
References: <4FDF2044020000780008A66F@nat28.tlf.novell.com>
 <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com> <4FE3040B020000780008B030@nat28.tlf.novell.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 21 Jun 2012 08:19:43 -0600
Message-ID: <CAErSpo4Nc0RjwDEhwt=BLaKez2KRxVoVBc5EENG53VBMzgg67Q@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: adjust section annotations
To: Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-cris-kernel@axis.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 3:22 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 21.06.12 at 02:06, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Mon, Jun 18, 2012 at 4:34 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>> DMI tables referenced from __init code only can be __initconst, and as
>>> a result the functions referenced from there can become __init.
>>>
>>> pcibios_setup() can be __init as being a command line parsing function
>>> only.
>>>
>>> A few other variables can then also have their attributes adjusted.
>>
>> This seems OK as far as it goes.
>>
>> However, if you're going to make pcibios_setup() __init for x86, I'd
>> really encourage you to make it consistent across all the other
>> architectures.  And if you do *that*, I think it would be cool if you
>> supplied a generic do-nothing "weak" version in the PCI core.  That
>> would allow you to remove it altogether from alpha, ia64, microblaze,
>> mips pmc-sierra, parisc, powerpc, sh, sparc, tile, and xtensa.
>
> I'd prefer to leave this to the respective arch maintainers, the
> patch here really was meant to be x86 specific (as its title says).

OK.  Ingo, do you want to take this after all?

If I push stuff through my PCI tree, I try really hard to make PCI
overall more consistent, not less consistent, so I'm not very
interested in taking minor improvements to just one arch.

Bjorn
