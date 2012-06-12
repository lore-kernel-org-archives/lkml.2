Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2FLVdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:33:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52291 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2FLVdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:33:20 -0400
MIME-Version: 1.0
X-Originating-IP: [184.183.177.134]
In-Reply-To: <CAK9+cJX9dSf0H9_W-HjQK3t6DUVtQnvfd-+e_hTUYTuNXnWT=A@mail.gmail.com>
References: <CAK9+cJX9GHjToKbOqqmink5Kr-9y3ZhQPC8M8rcL70rWbbYVYw@mail.gmail.com>
	<4FD7AF24.8080607@zytor.com>
	<CAK9+cJXLYX_20Xovy5Th7aXcznVf--RzF+GxxOWiv2gX6pETng@mail.gmail.com>
	<4FD7B1AB.6030708@zytor.com>
	<CAK9+cJX9dSf0H9_W-HjQK3t6DUVtQnvfd-+e_hTUYTuNXnWT=A@mail.gmail.com>
Date: Tue, 12 Jun 2012 17:33:19 -0400
Message-ID: <CAK9+cJW=YLGXCLRM4+MCgkQpFkp5Q6+K4v44MA6xL54GFA7a_A@mail.gmail.com>
Subject: Re: [question] x86/x86_64 boot process
From: Brandon Falk <bfalk@gamozolabs.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be reasonable to put the setup code at 0x7c00 (given that I
can fit my boot loader in the space before the kernel header)?

On Tue, Jun 12, 2012 at 5:20 PM, Brandon Falk <bfalk@gamozolabs.com> wrote:
> It's currently only for learning purposes, and I will change loading
> from 0x90000. Thanks for the help, now that I know that I'm
> responsible for loading the protected-mode code, I know what to do
> next.
>
> On Tue, Jun 12, 2012 at 5:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/12/2012 02:14 PM, Brandon Falk wrote:
>>> All I really see related to the post-setup stage is:
>>>
>>> 'The 32-bit (non-real-mode) kernel starts at offset (setup_sects+1)*512
>>> in the kernel file (again, if setup_sects == 0 the real value is 4.)
>>> It should be loaded at address 0x10000 for Image/zImage kernels and
>>> 0x100000 for bzImage kernels.'
>>>
>>> I've read this document a few times, and it doesn't seem to mention if
>>> the kernel assists in loading. Do I have to load up the whole
>>> protected-mode kernel? Just the first few sectors? I guess that's what
>>> I'm trying to figure out, and I feel the boot.txt has not answered
>>> that for me.
>>>
>>
>> I would also strongly discourage you from writing a new bootloader if
>> you can avoid it.  You *certainly* want to avoid the use of the fixed
>> 0x90000 address, that is a decade obsolete.
>>
>>        -hpa
>>
