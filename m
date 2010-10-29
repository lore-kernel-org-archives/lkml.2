Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887Ab0J2NFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:05:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45951 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab0J2NFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:05:23 -0400
Message-ID: <4CCAC68F.7050903@codemonkey.ws>
Date: Fri, 29 Oct 2010 08:05:19 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: virtualization@lists.linux-foundation.org,
        QEMU Developers <qemu-devel@nongnu.org>, virtualization@lists.osdl.org,
        Ian Molton <ian.molton@collabora.co.uk>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk> <4CBD7560.6080207@redhat.com>	<4CC8226F.5080807@collabora.co.uk> <201010292148.01167.rusty@rustcorp.com.au>
In-Reply-To: <201010292148.01167.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2010 06:18 AM, Rusty Russell wrote:
>> Fixed - updated patch tested and attached.
>>      
> OK. FWIW, I think this is an awesome idea.

Paravirtual OpenGL or the actual proposed implementation?  Have you 
looked at the actual code?

If I understand correctly, the implementation is an RPC of opengl 
commands across virtio that are then rendered on the host to an 
offscreen buffer.  The buffer is then sent back to the guest in rendered 
form.

But it's possible to mess around with other guests because the opengl 
commands are not scrubbed. There have been other proposals in the past 
that include a mini JIT that would translate opengl commands into a safe 
form.

Exposing just an opengl RPC transport doesn't seem that useful either.  
It ought to be part of a VGA card in order for it to be integrated with 
the rest of the graphics system without a round trip.

The alternative proposal is Spice which so far noone has mentioned.  
Right now, Spice seems to be taking the right approach to guest 3d support.

Regards,

Anthony Liguori

>    I understand others are skeptical,
> but this seems simple and if it works and you're happy to maintain it I'm
> happy to let you do it :)
>
> Cheers,
> Rusty.
>
>    

