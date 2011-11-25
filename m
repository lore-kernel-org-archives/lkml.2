Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1KYQQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 11:16:33 -0500
Received: from mx01.edigma.com ([195.22.21.235]:56642 "EHLO mx01.edigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab1KYQQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 11:16:32 -0500
Message-ID: <4ECFBF56.4000002@edigma.com>
Date: Fri, 25 Nov 2011 16:16:22 +0000
From: Nuno Santos <nsantos@edigma.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com> <4ECF8528.9080800@gmail.com>
In-Reply-To: <4ECF8528.9080800@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Thanks for your reply.

The algorithm is a matrix transform computation to make a affine a 
geometric transform.

Basicly it is based on the following functions:

http://pastebin.com/YHzYuLPU

Curiously I ran a test before writing this email and guest what.... is 
working!! :)

But now that I have opened this question here I should ask... is it safe?

This is the call to the function i'm making in kernel side (most of the 
computation are made in userspace during a calibration and only 
calculated data goest back to kernel. Then, in runtime inside the driver 
I need to call this function:

mx3d_transform(src, zone->Matrix, tex);

Which is defined in the pastebin above.

And the input data is the following:

src[0] = [0,6300]; src[1] = [0,6300]; src[2] = 1.0;
zone->Matrix (double[3][3])

u: 492.188 v: 615.234 sx: 683.158 sy: 5790.13

u: 5807.81 v: 615.234 sx: 5944.9 sy: 5900.58

u: 5807.81 v: 5684.77 sx: 6027.46 sy: 560.337

u: 492.188 v: 5684.77 sx: 751.198 sy: 476.455


and tex is output (double[3])

I'm not protecting the call to the function with kernel_fpu_begin and 
kernel_fpu_end

Should I be happy with the results or should I be concerned in 
converting this function only to integer?

I hope I have been clear in my language.

Thanks,

With my best regards,

Nuno

On 11/25/2011 12:08 PM, Jiri Slaby wrote:
> On 11/25/2011 12:14 PM, Nuno Santos wrote:
>> Doing a grep -r kernel_fpu_begin * on kernel source dir I can find
>> several references to this functions but not them is included in the
>> include dir. Which include do I need to have this functions found in
>> compile time?
> It is defined in arch specific includes. For x86 in asm/i387.h (in
> arch/x86/include).
>
>> Am I even sailing in the right direction?
> You should generally not use that anyway. It's not portable and disables
> preemption.
>
> Can't you do the computations in userspace? And why it cannot be
> switched to integer types -- what algorithm is that? Some math function?
>
> reagards,


