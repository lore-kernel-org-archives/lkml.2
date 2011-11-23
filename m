Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1KWVlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:41:40 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:57643 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab1KWVlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:41:39 -0500
Message-ID: <4ECD6873.7080106@metafoo.de>
Date: Wed, 23 Nov 2011 22:41:07 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Ian Abbott <abbotti@mev.co.uk>
CC: Dan Carpenter <dan.carpenter@oracle.com>, Xi Wang <xi.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <ian.abbott@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com> <20111123061355.GA3295@mwanda> <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com> <20111123145020.GA3258@mwanda> <4ECD1A01.3060503@mev.co.uk>
In-Reply-To: <4ECD1A01.3060503@mev.co.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 05:06 PM, Ian Abbott wrote:
> On 2011-11-23 14:50, Dan Carpenter wrote:
>> On Wed, Nov 23, 2011 at 08:59:52AM -0500, Xi Wang wrote:
>>> Thanks for the pointer.  However you cannot do the overflow check using
>>>
>>>    if (sizeof(struct comedi_insn) * insnlist.n_insns < 
>>> insnlist.n_insns)
>>>
>>> Let's assume 32-bit system, sizeof(struct comedi_insn) = 32, and
>>> insnlist.n_insns = 0x7fffffff.
>>>
>>> Note that 32 * 0x7fffffff = 0xffffffe0 overflows but bypasses your
>>> check.
>>>
>>
>> Argh...  You're right, my check is wrong.  What I like about my patch
>> though is that it doesn't introduce an arbitrary limit.  Could you
>> redo your check without the MAX_INSNS?
> 
> Could use something like:
> 
>     if (insnlist.n_insns <= ULONG_MAX / sizeof(struct comedi_insn))
>         insns =
>             kmalloc(sizeof(struct comedi_insn) * insnlist.n_insns,
>                 GFP_KERNEL);
>     if (!insns)
>         ...
> 
> (note that insns is initialized to NULL).
> 

Just use kcalloc, it will do the right thing for you.

- Lars
