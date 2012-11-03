Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2KCNUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 09:20:20 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47445 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab2KCNUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 09:20:17 -0400
Message-ID: <50951A0E.9010103@redhat.com>
Date: Sat, 03 Nov 2012 14:20:14 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ric Wheeler <rwheeler@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kay Sievers <kay@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
References: <20121025180045.GL11442@htj.dyndns.org> <1657557410.1945557.1351190120407.JavaMail.root@redhat.com> <20121031212241.GZ2945@htj.dyndns.org> <5093DD5E.6030808@redhat.com> <20121102165123.GB3823@mtj.dyndns.org> <509407B7.3030904@redhat.com> <20121102175350.GB27843@mtj.dyndns.org>
In-Reply-To: <20121102175350.GB27843@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/11/2012 18:53, Tejun Heo ha scritto:
> Hello, Paolo.
> 
> On Fri, Nov 02, 2012 at 06:49:43PM +0100, Paolo Bonzini wrote:
>>> No rule is really absolute.  To me, it seems the suggested in-kernel
>>> per-device command code filter is both too big for the given problem
>>
>> Is it?  150 lines of code?  The per-class filters would share the first
>> two patches with this series, add a long list of commands to filter, and
>> the ioctl would be on top of that.
> 
> It's not really about the lines of code.  It adds a new userland
> visible interface.  As for the "long" list of commands, it depends on
> how you write it but even if it's textually long it's still very
> simple in terms of actual complexity.

Sure, but its place is not the kernel.

As to implementing the ioctl, it's all but trivial.  For one thing, you
have to make the block device ioctl op take a "struct file".  I have
been asking Al Viro about it for 6 months and I haven't got any answer yet.

Second, getting a security-sensitive ioctl right is hard, as you
demonstrated yourself in this thread by proposing a gapingly insecure
approach.  Adding a little bit of customization to the current solution
may be but a local optimum, but you cannot really get it wrong.

>>> while being too limited for much beyond that.
>>
>> What are the use cases beyond these?  AFAIK these were the first two in
>> ten years or so...
> 
> If this is such a cold area, why do we want do anything other than the
> simplest possible?

Because _this_ is the simplest possible.

I proposed a way to implement the ultimately flexible solution (BPF) and
you shot it down because it was too complex.  Alan is showing you with
multiple examples of why the flexibility would be useful (perhaps nobody
would use it, but the use cases _are_ there), and you are mostly
ignoring them.

James suggested the sysfs knob, which is not as flexible but is the
simplest thing that can work, and was even part of the original design.
 You are still shooting it down because it is too complex, yet you're
proposing to replace one simple mechanism with two; one of which is
absolutely inflexible (unlike MMC which only has "ripping" and
"burning", other device classes have many use cases), while the other is
hard to both implement and get right.

Sounds great...

Paolo

>>> So, if we can get away
>>> with adding an ioctl, I personally think that would be a better
>>> approach.
>>
>> I would really prefer to get a green light from Jens/James for per-class
>> filters in the kernel (which are worth a few hundred lines of data)
>> before implementing that.
> 
> Sure, Jens, James?  Guys, come on.
> 
> Thanks.
> 

