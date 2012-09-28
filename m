Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab2I1O4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:56:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60783 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab2I1O4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <5065B909.1060907@cs.tu-berlin.de>
References: <5064790E.4000207@cs.tu-berlin.de> <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <CAPXgP11SN7cx7NW0Jv46g+KAvFPo61Ptczochzy4Ub83bjHn1Q@mail.gmail.com> <5065B909.1060907@cs.tu-berlin.de>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 28 Sep 2012 16:56:08 +0200
Message-ID: <CAPXgP12v0aNtUnhKep3QiJwZYAp=NHebHVfS9N35V2EOSmAufg@mail.gmail.com>
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
To: =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 4:49 PM, "Jan H. Schönherr"
<schnhrr@cs.tu-berlin.de> wrote:
> Am 28.09.2012 16:34, schrieb Kay Sievers:
>> On Fri, Sep 28, 2012 at 10:25 AM, Jan H. Schönherr

>> The current behaviour has the advantage, that non-cont users will not
>> race against a cont user (which is like 99.x% of the races I expect).
>> The cont buffer is currently only used when we expect a cont user,
>> non-cont users happening in the middle of a cont-print will not flush
>> the and disturb the cont buffer.
>
> That should be fixable by using a second set of flags, owner, and so on
> within vprintk... I still think, that getting rid of of remotely tracking
> the flags is worth something.

Sure, sounds fine in theory.

> (Ideally, we should also be able to correctly reassemble multiple
> simultaneous cont users. But that it still a bit out of scope I think.)

Yeah, that's messy, and not really worth it, I guess. We enter per-cpu
data and in_interrupt() territory with that, which is not really worth
the complexity for cont printing. The one separated cont buffer works
pretty well already.

> Given that I'm able to fix the racing case, would you be in favor of
> this approach, or should we stick to the earlier version?

I'm open to everything that makes sense. Let's see how it looks and we
can decide when we have something that passes the tests.

Thanks,
Kay
