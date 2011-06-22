Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab1FVKSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:18:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45119 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab1FVKSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DIO1bPMNJINDN0Q27fIhrMIW+eHrnmBdNboEOrjhcmDyq4S7AoM316CCiGxnaYcHPW
         hwefG2NEAkkPsh9m8aqtotCYDIzA0J86MhlmBKntcZJ3vFDoJ8f56EPas3+iT0osWkLr
         9a8DguYwc7fARuzmvKOgYALoOrS0i6d58C4E8=
MIME-Version: 1.0
In-Reply-To: <87r56m8w2b.fsf@rustcorp.com.au>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au>
 <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au>
 <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com> <87r56m8w2b.fsf@rustcorp.com.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 22 Jun 2011 12:17:49 +0200
Message-ID: <BANLkTimNpDdp+JBXt0wUjuc0awypJSvXRg@mail.gmail.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 04:00, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 22 Jun 2011 00:47:55 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Tue, Jun 21, 2011 at 03:53, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > Sorry, that's another vague answer :(
>> >
>> > udev already knows about module load
>>
>> Not for built-ins.
>
> OK, I re-read your commit message, and down the bottom it does say what
> it *does*:
>
>>        This adds the currently missing /sys/module/<name>/uevent files
>>        to all module entries.
>
> I apologize for skimming,

Absolutely no problem. Asking such questions can not be wrong.

> but this should be the *title* of the patch!

Right, it's hard sometimes from 'inside' to make good titles that make
titles that are properly understood 'outside'. If you have any better
idea, please just change it.

> Then I saw your patch hit params.c and thought you were adding a uevent
> file to /sys/module/<name>/parameters/.  I was even more confused when
> you replied:
>
>> Hook system management into module-load events, which might include
>> changing module parameters in /sys/module/*/parameters/*...
>
> Because loading a module might *create* module parameters, but it won't
> *change* them.  If we want to have events for change, we need much
> more...
>
> Now we've got that sorted, is there a reason why you changed all the
> signatures rather than just using mod->mkobj in store_uevent()?

Because we should be able to use the same 'struct module_attribute'
for built-in modules and for loaded modules at the same time. The
current 'struct module_attribute' has 'struct module' references, but
'struct module' will never exist for built-in modules.

'Struct module_kobject' has nice back-pointer to 'struct module', so
this was the simplest to do, and looks still fine, I thought.

Kay
