Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1JSPO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:14:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3883 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab1JSPO0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:14:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kLQPAMbkAzHfEN5QXyH+T18SK+wJ0GV9QJ87WF8vpgbye9nJPKf4wjyeXXLaMbVOE
	ITQ0y4QaZnYuqb1dHsweg==
MIME-Version: 1.0
In-Reply-To: <4E9EA2EC.2090900@n00bsys0p.co.uk>
References: <j7k7sf$vbf$1@dough.gmane.org> <CAErSpo7mhAsft5L4ifeWGhB+s2JQc8rbFEjJCfWEq7hW_8kR6A@mail.gmail.com>
 <4E9EA2EC.2090900@n00bsys0p.co.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 19 Oct 2011 09:14:04 -0600
Message-ID: <CAErSpo4pkpi77KkH=oQAaMmXRaAxCxqc6eTONhpgMZWhMOJG-Q@mail.gmail.com>
Subject: Re: Possible bug in via-velocity on 3.0+
To: n00b <n00b@n00bsys0p.co.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 4:14 AM, n00b <n00b@n00bsys0p.co.uk> wrote:
> On 18/10/11 17:15, Bjorn Helgaas wrote:
>>
>> On Tue, Oct 18, 2011 at 10:01 AM, n00bsys0p<n00b@n00bsys0p.co.uk>  wrote:
>>>
>>> Hi,
>>>
>>> I've been trying to get a custom 3.0 kernel to boot via PXE on a VIA EPIA
>>> EN15000G, and have run into a problem where once the thin client starts
>>> to
>>> load the kernel, the entire screen turns into a mosaic of random colours
>>> and
>>> characters.
>>>
>>> I've tested this serving a 2.6.35.8 kernel (configured identically to the
>>> 3.0) to the thin client where the master and client are both fitted with
>>> EPIA EN1500G, and it works perfectly. Also, I tried swapping the master's
>>> motherboard to a Gigabyte GA-D525TUD (Realtek LAN chip), and it succeeded
>>> in
>>> serving the 3.0 kernel to an EN15000G without a fault.
>>>
>>> In all test cases, the master was using a 3.0 kernel.
>>>
>>> Through this testing, I surmise that it is something to do with the LAN
>>> driver which is used, as this is the only thing I can see to have changed
>>> between the two running systems. Could it be accidentally overwriting the
>>> video RAM or something along those lines?
>>>
>>> Here's a link to a photo of what the screen looks like when it goes
>>> wrong:
>>>
>>> https://lh3.googleusercontent.com/-sXFP41oaF9U/TpyMFg89CqI/AAAAAAAAA-I/PBrltIm0cB4/s720/PXEFail.jpg
>>
>> Let me see if I understand this correctly:
>>
>>   - The problem is on the EN15000G client.
>>   - It occurs when the client boots 3.0 from a EN1500G server, but not
>> when booting the same 3.0 kernel image from a GA-D525TUD server.
>>   - It doesn't occur when booting 2.6.35.8 from a EN1500G server.
>>   - The client boots successfully and is usable, i.e., the only
>> problem is the temporary garbage on the screen during boot.
>>
>> It would be useful to see the complete dmesg log from 2.6.35.8 on the
>> client.  If 3.0 actually does boot on the client, a dmesg log from 3.0
>> would also be useful.  There might be a clue if we can compare them.
>>
>> Bjorn
>
> In answer:
>  - Yes, the problem is a client machine with an EN15000G board
>  - Correct, the 3.0 kernel image booted the client using a GA-D525TUD
> server, but not when using an EN15000G
>  - Correct again, the 2.6.35.8 image booted correctly from an EN15000G
> server
>  - Not correct. The problem is permanent when it occurs. The client machine
> has been left for hours, and all that is visible is the garbage on screen.

Good.  That's what I suspected, just wanted to make sure.

> I'm not sure if it was a one-off, but I can't appear to get it to serve the
> 3.0 kernel from the Gigabyte motherboard now. Exactly the same thing is
> happening as with the EN15000G (garbage mosaic).

Also good, that's what I would expect.  It would be very strange if
the same bits worked differently, depending on what server they came
from.

> I've attached the dmesg log from the client for the 2.6.35.8 kernel. If I
> manage to get the 3.0 kernel to boot again, I'll send over the dmesg log for
> that.

That makes this a regression between 2.6.35.8 and 3.0.  The easiest
(though tedious) way to find the problem is to bisect between those
versions (http://www.landley.net/writing/git-bisect-howto.html).

I don't see many interesting via-velocity changes since 2.6.35.  I'd
suspect some sort of video mode problem, given the screen issue.
Maybe you could learn something by turning off vesafb and the
bootsplash stuff.

Bjorn
