Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1E3HaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:30:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1E3HaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=crol5mzZk78JJsaGmH5Y9yDVVYF7C7HxiwjTaWAWbgNSEN0yBNsF+OSEnFO0xH/hVn
         /UWmMIUsbabiUDRrrug83wDxsVF4lQIQMWzNJ4XpubyVYGBbucnj9+0WwyW1jW5vx2rS
         a8120Job2jWemHl+sLV6v7YrPnth+krW0oZoQ=
MIME-Version: 1.0
In-Reply-To: <m1k4db61mm.fsf@fess.ebiederm.org>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
	<20110203020703.GB21603@redhat.com>
	<20110203135324.93BC.A69D9226@jp.fujitsu.com>
	<20110526131028.7052a893.akpm@linux-foundation.org>
	<m1k4db61mm.fsf@fess.ebiederm.org>
Date: Mon, 30 May 2011 15:30:06 +0800
Message-ID: <BANLkTins-BdVFnZkcVO+SJwYxNZRMT51vw@mail.gmail.com>
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 9:43 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
>
>> On Thu,  3 Feb 2011 13:53:01 +0900 (JST)
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>>> > > I wrote why this is no good idea by another mail. Please see it.
>>> > > Anyway you have a right to don't use this feature.
>>> > >
>>> >
>>> > But you have not explained that why do you need to hook into crash_kexec()
>>> > and you have also not explained why do you need to send out kdump_msg()
>>> > notification if kdump is configured.
>>> >
>>> > Some detailed explanation here would help.
>>>
>>> Hi,
>>>
>>> I send it you now :)
>>>
>>
>> What happened with this?  kexec-remove-kmsg_dump_kexec.patch has two acks
>> and one unexplained nack :(
>
> As I recall the nack was based on a theoretical use case, and a cleanup
> of kmsg_dump to make it more robust which I don't believe has happened,
> instead of something real.
>
> My feel is that we should remove kmsg_dump and if a real use case comes
> up reconsider it at that time.
>
> I don't think anyone cares too strongly at the moment because the
> features are not expected to be used in conjunction with each other, nor
> even expected to be compiled into the same kernel.  However given that
> they are not used to be used in conjunction with each other a call into
> kmsg_dump from crash_kexec is really just cluttering the code for no
> benefit to anyone.

Seiji once proposed NVRAM which uses kmsg_dump, he wants
to have another way to store panic information when kdump doesn't
work which is _not_ rare in the real world.
