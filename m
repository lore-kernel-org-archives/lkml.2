Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245Ab2CNCAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:00:52 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:61639 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170Ab2CNCAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP13D9haan4SdxhxzzKUaw=FV1JgP0weKmezK8tJBip4QXA@mail.gmail.com>
References: <201203032122.36745.chunkeey@googlemail.com> <201203132042.07794.rjw@sisk.pl>
 <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com>
 <201203140110.40671.rjw@sisk.pl> <CAPXgP118s+DuLaATKOq7w=F82GB=8PkwUJDichffXA-Er6Zqvw@mail.gmail.com>
 <CA+55aFxq=GWof-ExXjeC2nwUBcGi46SKwcvc2iccfymbbyXbfA@mail.gmail.com>
 <CAPXgP11ZKT-ZNBLdPQWotFayz9m7pKcNHDBPWxcp_2-ja+SAcQ@mail.gmail.com>
 <CA+55aFyG6utURVkVbAXF_T+BcA94af=c+oDBAwWZOyNwgiQ+5g@mail.gmail.com> <CAPXgP13D9haan4SdxhxzzKUaw=FV1JgP0weKmezK8tJBip4QXA@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 14 Mar 2012 03:00:30 +0100
Message-ID: <CAPXgP12HMUSdhg660PRX30YO2e2NU-kyjYHgR=AB+dm2TkrJeg@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 02:55, Kay Sievers <kay@vrfy.org> wrote:
> On Wed, Mar 14, 2012 at 02:51, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Tue, Mar 13, 2012 at 6:43 PM, Kay Sievers <kay@vrfy.org> wrote:
>>>
>>> usermodehelper_is_disabled() is a flag from kmod which is all about
>>> exec(). That flag should not be used to decide if a firmware request
>>> can be issued by a driver and queued up or not.
>>
>> Sorry, you're wrong. And Rafael *told* you why you are wrong, and you
>> ignored him and talked about "exec" some more.
>>
>> So go back and read Rafael's email. The point is, you are focusing too
>> much on the name (which Rafael talked about and said is misleading).
>>
>> But it's not the name that matters, it's the concept. Loading firmware
>> during the suspend process is broken (read Rafael's email about
>> suggested renaming).
>>
>> AND IT HAS NOTHING TO DO WITH EXEC. It doesn't matter *how* you load
>> it. You could load it by reading a file directly from disk, AND IT
>> WOULD STILL BE WRONG FOR THE EXACT SAME DAMN REASON.
>>
>> I outlined that reason too. The filesystem may not be up and running yet.
>>
>> Get it?
>>
>> So please, read the emails. People actually *agree* that the name may
>> be a bit misleading, but instead of harping on bogus issues, just read
>> the emails from people like Rafael about it.
>>
>> So STOP with this idiocy already. It has nothing to do with exec.
>> Seriously. Get that through your head already.
>
> I do NOT talk about exec, I talk about a REQUEST which can be QUEUED
> just fine, but which the kernel refuses to QUEUE, even when it will
> not harm anything. That check and warning is wrong.

In simpler words: request_firmware() does nothing but queue up an
asynchrounous uevent in a socket, that always workls, there is no need
to refuse that in the kernel and throw any warning at that point in
time.

Kay
