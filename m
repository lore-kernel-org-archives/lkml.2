Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1AHSJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 13:09:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51046 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1AHSJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 13:09:19 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1101081258560.24933@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
 <20110108055621.GB10391@suse.de> <Pine.LNX.4.64.1101080811400.29089@hs20-bc2-1.build.redhat.com>
 <AANLkTikg7vAG4-E=BD_sC=63R8fDCfEi_wiqnxDnUnK=@mail.gmail.com> <Pine.LNX.4.64.1101081258560.24933@hs20-bc2-1.build.redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 8 Jan 2011 19:09:03 +0100
Message-ID: <AANLkTi=hZ_W877QOwNK3=1-2S03VsKOXF_cVno_ReyrY@mail.gmail.com>
Subject: Re: kobject_put vs module unload
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 8, 2011 at 19:01, Mikulas Patocka <mpatocka@redhat.com> wrote:
> On Sat, 8 Jan 2011, Kay Sievers wrote:
>> On Sat, Jan 8, 2011 at 14:19, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > On Fri, 7 Jan 2011, Greg KH wrote:
>>
>> >> > 4) the reference obtained at point 1) is dropped, kobject reference count
>> >> > reaches zero and the release callback is called. But that callback points
>> >> > to an unloaded module and causes a crash.
>> >> >
>> >> > How is it solved? Am I missing something?
>> >>
>> >> You have the code that creates and frees the object, to not be in the
>> >> module that could have been unloaded.  It's really just that simple.
>> >
>> > If the whole device mapper subsystem can be a module, where can I put the
>> > code?
>> >
>> > I think a similar bug exists in md, it can also be unloaded as a module
>> > and it has "release" method in its module code.
>>
>> If you still have data structures hanging around, these structures are
>> supposed to take a reference on the module -- and you can not unload
>> the module as long as this is the case.
>>
>> Kay
>
> kobject references don't increase module reference count. If kobject held
> module references, it would be a fix for this bug, but could cause other
> bugs (some modules could be unloadable due to self-references to its own
> kobjects).

Sure, they don't automatically take references. It's the job of the
driver/module, to make sure to pin the module for any data of it,
which might be still in use.

Kay
