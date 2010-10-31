Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0JaBLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 21:11:06 -0400
Received: from mx5.orcon.net.nz ([219.88.242.55]:53710 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab0JaBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 21:11:04 -0400
Message-ID: <4CCCC224.50007@orcon.net.nz>
Date: Sun, 31 Oct 2010 14:11:00 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux alpha; en-US; rv:1.9.1.14) Gecko/20101026 Icedove/3.0.9
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Matt Turner <mattst88@gmail.com>, Jiri Kosina <trivial@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/39] arch/alpha: Update WARN uses
References: <cover.1288471897.git.joe@perches.com>	 <517a3d5c620dd4843a35a05c9a1c123b4b936cd9.1288471898.git.joe@perches.com>	 <AANLkTi=Po5RaY-mL62trrVm+kuK=0JV7z2oQcDJek4kE@mail.gmail.com> <1288474087.366.145.camel@Joe-Laptop>
In-Reply-To: <1288474087.366.145.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx5.orcon.net.nz on Sun, 31 Oct 2010 14:11:01 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Oct 31 14:11:02 2010
X-DSPAM-Confidence: 0.8531
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/10 10:28, Joe Perches wrote:
> On Sat, 2010-10-30 at 17:17 -0400, Matt Turner wrote:
>> On Sat, Oct 30, 2010 at 5:08 PM, Joe Perches<joe@perches.com>  wrote:
>>> Coalesce long formats.
>>> Align arguments.
>>> Signed-off-by: Joe Perches<joe@perches.com>
>>>   arch/alpha/kernel/pci-sysfs.c |   14 ++++++--------
>>>   1 files changed, 6 insertions(+), 8 deletions(-)
>>> diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
>>> @@ -44,10 +44,9 @@ static int __pci_mmap_fits(struct pci_dev *pdev, int num,
>>> -       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d "
>>> -               "(size 0x%08lx)\n",
>>> -               current->comm, sparse ? " sparse" : "", start, start + nr,
>>> -               pci_name(pdev), num, size);
>>> +       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",
>>> +            current->comm, sparse ? " sparse" : "", start, start + nr,
>>> +            pci_name(pdev), num, size);
>>> @@ -261,10 +260,9 @@ static int __legacy_mmap_fits(struct pci_controller *hose,
>>> -       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d "
>>> -               "(size 0x%08lx)\n",
>>> -               current->comm, sparse ? " sparse" : "", start, start + nr,
>>> -               hose->index, size);
>>> +       WARN(1, "process \"%s\" tried to map%s 0x%08lx-0x%08lx on hose %d (size 0x%08lx)\n",
>>> +            current->comm, sparse ? " sparse" : "", start, start + nr,
>>> +            hose->index, size);
>> What's accomplished here? It looks like you joined two strings (which
>> were separated as to not overflow the 80-char limit) and spaced a
>> couple lines over.
>>
>> I don't see how this makes anything clearer.
>
> This one is just a whitespace cleanup.
> Ignore it or nack it if you want.

I prefer the original indenting as it clearly stands the `1' on its own 
thus emphasising that the warning will be printed everytime the WARN() 
statement is executed.  I surmise that the original programmer thought 
it important to emphasise this as it might not be considered the 
"normal" usage of WARN().

I agree that, in general, coalesced strings aid grepping but this broken 
string isn't one that will benefit.

I recall the story that when someone pointed out parallel fifths (an 
absolute no-no according to the rules of classical harmony) in a 
composition of Beethoven's to Beethoven himself, Beethoven was so 
indignant that he proceeded to compose a set of variations on a theme 
where in each variation he extensively violated one of the rules of 
classical harmony, and wrote down the bottom of each variation "You Ass" 
to the authority who had made the rule.

The moral here is that when a _competent_ programmer breaks the "style 
guide" they are most likely doing so for a very good reason.  Thus, 
those who would submit whitespace fix patches should take time to ask 
themselves why the original programmer has laid out the code in such a 
fashion and learn from it, before submitting so-called "fixes".

Cheers
Michael.
