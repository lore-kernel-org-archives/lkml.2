Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2FLVOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:14:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63038 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2FLVOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:14:16 -0400
MIME-Version: 1.0
X-Originating-IP: [184.183.177.134]
In-Reply-To: <4FD7AF24.8080607@zytor.com>
References: <CAK9+cJX9GHjToKbOqqmink5Kr-9y3ZhQPC8M8rcL70rWbbYVYw@mail.gmail.com>
	<4FD7AF24.8080607@zytor.com>
Date: Tue, 12 Jun 2012 17:14:16 -0400
Message-ID: <CAK9+cJXLYX_20Xovy5Th7aXcznVf--RzF+GxxOWiv2gX6pETng@mail.gmail.com>
Subject: Re: [question] x86/x86_64 boot process
From: Brandon Falk <bfalk@gamozolabs.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All I really see related to the post-setup stage is:

'The 32-bit (non-real-mode) kernel starts at offset (setup_sects+1)*512
in the kernel file (again, if setup_sects == 0 the real value is 4.)
It should be loaded at address 0x10000 for Image/zImage kernels and
0x100000 for bzImage kernels.'

I've read this document a few times, and it doesn't seem to mention if
the kernel assists in loading. Do I have to load up the whole
protected-mode kernel? Just the first few sectors? I guess that's what
I'm trying to figure out, and I feel the boot.txt has not answered
that for me.

On Tue, Jun 12, 2012 at 5:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2012 01:49 PM, Brandon Falk wrote:
>> Greetings. Please CC me on any responses as I do not subscribe to the list.
>>
>> I'm currently working on a very very small boot loader. Currently it
>> uses BIOS int 0x13 to load up the 'setup' segments to 0x9000:0x0000. I
>> jump to this location, set up the kernel options, and then jump to
>> 0x9020:0x0000. Everything goes great. However, I get the message 'No
>> setup signature found...'. I'm assuming this is due to not loading up
>> the protected-mode code. I'm slightly confused as to how the protected
>> mode code is to be loaded. As my 'bzImage' is 2.6MB, I would need to
>> raise the A20 line to possibly load this up. Does the kernel assist in
>> this process at all? Should I set up a code32_start routine for my
>> code to load up the kernel? Once I'm in protected mode, how will I
>> even access the medium that the kernel is loaded from without creating
>> a driver?
>>
>> Currently the medium is a floppy image loaded in VMWare. It's a 64-bit
>> system. I'm just looking to be pointed in the right direction for the
>> next step (and if my current steps are valid for Protocol 2.10).
>>
>> Here's the current code (the code is manually overwritten onto the
>> bzImage, however only the code... the headers are left intact on the
>> bzImage):
>>
>
> Please read Documentation/x86/boot.txt.
>
>        -hpa
>
