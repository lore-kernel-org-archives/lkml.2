Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab0J1OYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:24:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759148Ab0J1OYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:24:48 -0400
Message-ID: <4CC98784.7020907@redhat.com>
Date: Thu, 28 Oct 2010 16:24:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        virtualization@lists.osdl.org
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk> <4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk> <4CBD7560.6080207@redhat.com> <4CC8226F.5080807@collabora.co.uk> <4CC94203.1080207@redhat.com> <4CC9647A.50108@collabora.co.uk>
In-Reply-To: <4CC9647A.50108@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/28/2010 01:54 PM, Ian Molton wrote:
>> Well, I like to review an implementation against a spec.
>
>
> True, but then all that would prove is that I can write a spec to 
> match the code.

It would also allow us to check that the spec matches the requirements.  
Those two steps are easier than checking that the code matches the 
requirements.

> The code is proof of concept. the kernel bit is pretty simple, but I'd 
> like to get some idea of whether the rest of the code will be accepted 
> given that theres not much point in having any one (or two) of these 
> components exist without the other.

I guess some graphics people need to be involved.

>
>> Better, but still unsatisfying. If the server is busy, the caller would
>> block. I guess it's expected since it's called from ->fsync(). I'm not
>> sure whether that's the best interface, perhaps aio_writev is better.
>
> The caller is intended to block as the host must perform GL rendering 
> before allowing the guests process to continue.

Why is that?  Can't we pipeline the process?

>
> The only real bottleneck is that processes will block trying to submit 
> data if another process is performing rendering, but that will only be 
> solved when the renderer is made multithreaded. The same would happen 
> on a real GPU if it had only one queue too.
>
> If you look at the host code, you can see that the data is already 
> buffered per-process, in a pretty sensible way. if the renderer itself 
> were made a seperate thread, then this problem magically disappears 
> (the queuing code on the host is pretty fast).

Well, this is out of my area of expertise.  I don't like it, but if it's 
acceptable to the gpu people, okay.

>
> In testing, the overhead of this was pretty small anyway. Running a 
> few dozen glxgears and a copy of ioquake3 simultaneously on an intel 
> video card managed the same framerate with the same CPU utilisation, 
> both with the old code and the version I just posted. Contention 
> during rendering just isn't much of an issue.

-- 
error compiling committee.c: too many arguments to function

