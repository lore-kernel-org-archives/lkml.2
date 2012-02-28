Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2B1AIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:08:38 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61064 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2B1AIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:08:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.76.133 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4BF11E.4090000@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
Date: Tue, 28 Feb 2012 01:08:36 +0100
Message-ID: <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Bodo Eggert <7eggert@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/27 H. Peter Anvin <hpa@zytor.com>:
> On 02/27/2012 11:23 AM, Joshua C. wrote:
>> I rebased this on the latest kernel-3.3-rc5 so that it can be properly applied.
>> ------------------
>>
>> From 36e15b8d9d491817a3bada5ef9375aabe9439d9b Mon Sep 17 00:00:00 2012
>> From: Joshua Cov <joshuacov@googlemail.com>
>> Date: Mon, 27 Feb 2012 20:49:18 +0100
>> Subject: [PATCH] Use BIOS Keyboard variable to set Numlock
>>
>> The PC BIOS does provide a NUMLOCK flag containing the desired state
>> of this LED. Bit 0x417 has the current keyboard modifier state. This
>> patch sets the current state according to the data in the bios and
>> introduces a module parameter "numlock" which can be used to
>> explicitely disable the NumLock (1 = enable, 0 = disable).
>>
>> See first discussion back in 2007 at:
>> http://lkml.indiana.edu/hypermail/linux/kernel/0707.1/1834.html
>>
>> Signed-Off-By: Joshua Cov <joshuacov@googlemail.com>
>> Cc: H. Peter Anvin <hpa@zytor.com>
>> Cc: Bodo Eggert <7eggert@gmx.de>
>>
>
> A better idea might be to query the status in the BIOS bootstrap code --
> then non-BIOS boots can do the equivalent.  It also has the side benefit
> of making people running Grub2 perhaps realize that they are f****ng
> themselves over by using the "linux" command and not "linux16", because
> of course policy in Grub2 is that if there is a sane way to do it, make
> sure it is NOT the default.
>
>        -hpa
>

Do you mind querying the state in Grub? This will mean that we'll have
to remove the code that sets this bit from the kernel and leave it the
in the state reported by the grub?

If so I'm not sure about it. We check the BIOS data area as defined
for IBM PCs (1981), so a fair amount of user should benefit from the
change. Those non-BIOS boots can set the numlock=0 and won't be
affected by this. I think this isa lot easier to implement than doing
it in the BIOS bootstrap code.
