Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0CVILK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:11:10 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:33740 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0CVILI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a2Q0xWuRGjh5goM2LU28ZYHd7DPCDa3YV3QS3ik5OYKH6kjaKS2hL91nfX8LnHIhDS
         IaSiC7um4CL+60/EJQFhLV4G3Q6EG7nfwNDZJjIvskaS8baznp5Yd1igHqqh+I1td1ow
         OTlUZXUPi6jPkQ7JN30N3NVm1u8s9rQzSMGTk=
MIME-Version: 1.0
In-Reply-To: <87wrx5m1h3.fsf@pollan.anholt.net>
References: <ho2jal$oqs$1@dough.gmane.org> <87wrx5m1h3.fsf@pollan.anholt.net>
Date: Mon, 22 Mar 2010 09:11:06 +0100
Message-ID: <bad735c81003220111y44bfb828vfd4c9fbbcabf3419@mail.gmail.com>
Subject: Re: i915 lockup / extreme delay
From: Karl Vogel <karl.vogel@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 5:20 AM, Eric Anholt <eric@anholt.net> wrote:
> On Sat, 20 Mar 2010 14:41:41 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:
>> The 'effect' is that only the mouse pointer works in the X server. The
>> cpu usage on the laptop during the sluggishness is minimal. When I
>> suspend the game with winedbg, the X server slowly becomes responsive again.
>>
>> The output from latencytop seems to point to i915 being the culprit:
>
> If there's some code doing glFlush()es, it's probably that code at
> fault.  You don't need to do that unless you're doing frontbuffer
> rendering, and if you're doing frontbuffer rendering you should really
> be doing backbuffer rendering.  I don't see a kernel issue here.

That doesnt explain why the box completely locks up on 2.6.34-rc2
though, where only a cold reboot works.

It also seems a bit odd that 1 opengl application is able to entirely
lockup user interaction of the X server, then again that might be more
of an X issue than a kernel one.. or is it expected behaviour?
(the only thing you can do is wiggle the pointer, nothing else.. no
window selection, no window dragging, not even start new apps that
open windows)
