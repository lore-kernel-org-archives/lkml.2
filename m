Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0DNRVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:21:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:41576 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab0DNRVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WBUyhEKScuPj143kpHyNCKLxKpHmx8XMMX3Q31fK9Yf8JNOaknxSPu8tmglM+2vy8r
         9FvkTf5uD6UQ5inJLp4Ua2nmh92itltY0hLWIryAYNk8Ai8RraQdSt8lIXGLGLDICxWp
         RsxbX3qSNwX5/4yA43ODu27GUwnRgXjKtVYQo=
MIME-Version: 1.0
In-Reply-To: <20100414163637.GV30807@buzzloop.caiaq.de>
References: <t2w74fd948d1004140347k3447bffapb73856eacddfde55@mail.gmail.com>
	 <Pine.LNX.4.44L0.1004141003170.1716-100000@iolanthe.rowland.org>
	 <20100414163637.GV30807@buzzloop.caiaq.de>
Date: Wed, 14 Apr 2010 18:21:05 +0100
Message-ID: <n2k74fd948d1004141021r8815647cx2b74085fc37a27b2@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2010 17:36, Daniel Mack <daniel@caiaq.de> wrote:
> On Wed, Apr 14, 2010 at 10:08:47AM -0400, Alan Stern wrote:
>> On Wed, 14 Apr 2010, Pedro Ribeiro wrote:
>> > On 14 April 2010 11:09, Daniel Mack <daniel@caiaq.de> wrote:
>> > > Thanks! So the only thing I can do for now is submit exactly this patch.
>> > > At least, it helps you and it shouldn't break anything. The question
>> > > remains whether this type of memory should be used for all
>> > > transfer_buffers.
>> > >
>> >
>> > Is there any chance you could push this to -stable? I don't care
>> > because I always use the latest kernel, but the next Debian stable and
>> > Ubuntu LTS are going to use 2.6.32.
>>
>> No!  Please don't do it: Don't submit the patch and _certainly_ don't
>> submit it to -stable.  It doesn't fix anything; it only works around a
>> bug, and at the moment we don't even know if the bug is in the kernel
>> or in Pedro's hardware (and even though it affects two different
>> systems of his, nobody else has reported a similar problem).  Papering
>> over it will only remove the incentive to fix it properly.
>
> No worries - I agree. But unfortunately, I'm out of ideas now, and my
> initial thoughts about what might cause the trouble were abviously not
> able to explain the issue. Does anyone see further steps of tracking
> this issue down?
>
> Thanks,
> Daniel
>

Well if this is a dirty / dangerous hack, what about your first patch?
I've been testing it for days and has given me no problems.

The best way to trigger the issue is to connect a dib0700 based DVB
adapter. All you need is to connect it. Since it polls for the remote
control every 50 msec, it causes a constant interference. Beware that
on 2.6.34 this behaviour has been corrected. Other DVB adapters may
trigger the same issue if they also poll constatly for the rc.

Regards,
Pedro
