Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0LFQbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:31:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62098 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab0LFQbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V6FTCyU3P0iHZMcbOB/aVJ7v7oAV7f3ezMs2unz+xg9EJqlGkGZKK66XmcbKqfDg+r
         gas95f30idNJmRrGOZ268PE/zIB/iT4Gw0P6gGsSY20OWEiONcBiLYgsBf0uwuLaV+tv
         0ifg8hw4zkckufpfg3FmkgatWOK5v3Hqf8U8E=
MIME-Version: 1.0
In-Reply-To: <20101206145852.GA24977@basil.fritz.box>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <878w03t4sn.fsf@basil.nowhere.org> <20101206135637.GC8135@thunk.org> <20101206145852.GA24977@basil.fritz.box>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 6 Dec 2010 17:31:04 +0100
Message-ID: <AANLkTin9=zCbfwdt0GxaGMynTqUsf8R4GWJy88qw87A_@mail.gmail.com>
Subject: Re: [Patch 00/15] Reduce tracing payload size.
To: Andi Kleen <andi@firstfloor.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, David Sharp <dhsharp@google.com>,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, mrubin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 3:58 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Mon, Dec 06, 2010 at 08:56:37AM -0500, Ted Ts'o wrote:
>> On Mon, Dec 06, 2010 at 02:22:00PM +0100, Andi Kleen wrote:
>> > David Sharp <dhsharp@google.com> writes:
>> > >
>> > > These patches are just a start to shrinking the size of trace events. I am
>> > > planning to also make small versions of trace events that are used when
>> > > CONFIG_SMALL_TRACES is enabled. I'm also open to discussion of other ways to
>> > > shrink event sizes.
>> >
>> > Maybe the simplest would be to lzo them as they get logged?
>> > I assume you already considered that?
>>
>> The tracing subsystem is supposed to be extremely low-overhead.
>> Compressiong the event log would add considerable CPU overhead.  If we
>
> lzo as a rule of thumb is about as expensive as 3x memcpy()
> That's not really expensive.

That is true for the decompression step but not for the compression
one, which takes more than 10 memcpys().

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
