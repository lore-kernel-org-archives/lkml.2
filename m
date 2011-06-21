Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1FUWsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:48:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44890 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab1FUWsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LgvCOZMwblNvMjz5u6O9DN4ZY7DQVmDLphJyqVfl2DrhK2UKrbHpyqJYqGV9L4PyTa
         x3gUSt8wDAid7ckJ4pkMAKfOBUBTE3Ub7mBvh2JmxsuISUSUc/bPIQq4j5q1kqTYu2NX
         /k7S4wwWJVublDc+uj2pX+s/+vIDl4JtRhFzY=
MIME-Version: 1.0
In-Reply-To: <87boxshrwe.fsf@rustcorp.com.au>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au>
 <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 22 Jun 2011 00:47:55 +0200
Message-ID: <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 03:53, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 20 Jun 2011 13:20:00 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Mon, Jun 20, 2011 at 01:23, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > On Sun, 19 Jun 2011 00:00:29 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> >> From: Kay Sievers <kay.sievers@vrfy.org>
>> >> Subject: module: sysfs - add 'uevent' file to allow built-in coldplug
>> >>
>> >> Userspace wants to manage module parameters with udev rules.
>> >> This currently only works for loaded modules, but not for
>> >> built-in ones.
>> >
>> > I'm confused.  What does "manage" mean here?
>>
>> Hook system management into module-load events, which might include
>> changing module parameters in /sys/module/*/parameters/*, or at
>> bootup/coldplug run it for built-in modules.
>>
>> We do the same to set properties for buses, drivers or devices when they appear.
>
> Sorry, that's another vague answer :(
>
> udev already knows about module load

Not for built-ins.

> and the parameters are created at
> that point; they are not *changed*.

The can be changed, and sometimes they need.

> What, *exactly* will this enable?  Don't use the word "hook" or
> "management": both vague terms which assume I know what you're talking
> about.  I don't.

Just used these words because it's absolutely generic infrastructure
we use already everywhere in /sys. :) Just run a: find /sys -name
uevent


> Show me exactly what udev will now be able to do that it can't do now,
> and how it will be used.  Preferably with examples.  Assume (correctly)
> that I have only a vague idea what udev does.

Set the polling interval of a always-built-in module parameter:

SUBSYSTEM=="module", KERNEL=="block",
ATTR{parameters/events_dfl_poll_msecs}="2000"

http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=c5a41da94916815ac14d950a0547bffc4411f7af

Kay
