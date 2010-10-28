Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab0J1Onr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:43:47 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46510 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab0J1Ono (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:43:44 -0400
Message-ID: <4CC98C25.9010207@codemonkey.ws>
Date: Thu, 28 Oct 2010 09:43:49 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Lightning/1.0b1 Thunderbird/3.0.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ian Molton <ian.molton@collabora.co.uk>, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk>	<4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk>	<4CBD7560.6080207@redhat.com> <4CC8226F.5080807@collabora.co.uk>	<4CC94203.1080207@redhat.com> <4CC9647A.50108@collabora.co.uk> <4CC98784.7020907@redhat.com>
In-Reply-To: <4CC98784.7020907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 09:24 AM, Avi Kivity wrote:
>  On 10/28/2010 01:54 PM, Ian Molton wrote:
>>> Well, I like to review an implementation against a spec.
>>
>>
>> True, but then all that would prove is that I can write a spec to 
>> match the code.
>
> It would also allow us to check that the spec matches the 
> requirements.  Those two steps are easier than checking that the code 
> matches the requirements.

I'm extremely sceptical of any GL passthrough proposal.  There have 
literally been half a dozen over the years and they never seem to leave 
proof-of-concept phase.  My (limited) understanding is that it's a 
fundamentally hard problem that no one has adequately solved yet.

A specifically matters an awful lot less than an explanation of how the 
problem is being solved in a robust fashion such that it can be reviewed 
by people with a deeper understanding of the problem space.

Regards,

Anthony Liguori

>> The code is proof of concept. the kernel bit is pretty simple, but 
>> I'd like to get some idea of whether the rest of the code will be 
>> accepted given that theres not much point in having any one (or two) 
>> of these components exist without the other.
>
> I guess some graphics people need to be involved.
>
>>
>>> Better, but still unsatisfying. If the server is busy, the caller would
>>> block. I guess it's expected since it's called from ->fsync(). I'm not
>>> sure whether that's the best interface, perhaps aio_writev is better.
>>
>> The caller is intended to block as the host must perform GL rendering 
>> before allowing the guests process to continue.
>
> Why is that?  Can't we pipeline the process?
>
>>
>> The only real bottleneck is that processes will block trying to 
>> submit data if another process is performing rendering, but that will 
>> only be solved when the renderer is made multithreaded. The same 
>> would happen on a real GPU if it had only one queue too.
>>
>> If you look at the host code, you can see that the data is already 
>> buffered per-process, in a pretty sensible way. if the renderer 
>> itself were made a seperate thread, then this problem magically 
>> disappears (the queuing code on the host is pretty fast).
>
> Well, this is out of my area of expertise.  I don't like it, but if 
> it's acceptable to the gpu people, okay.
>
>>
>> In testing, the overhead of this was pretty small anyway. Running a 
>> few dozen glxgears and a copy of ioquake3 simultaneously on an intel 
>> video card managed the same framerate with the same CPU utilisation, 
>> both with the old code and the version I just posted. Contention 
>> during rendering just isn't much of an issue.
>

