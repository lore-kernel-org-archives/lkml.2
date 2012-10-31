Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423056Ab2JaOyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:54:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54324 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423026Ab2JaOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
Date: Wed, 31 Oct 2012 10:54:32 -0400
Message-ID: <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Josh Boyer <jwboyer@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:50 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 29 Oct 2012, Matthew Garrett wrote:
>
>> > > This is pretty much identical to the first patchset, but with the capability
>> > > renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
>> > > to deploy these then they should disable kexec until support for signed
>> > > kexec payloads has been merged.
>> >
>> > Apparently your patchset currently doesn't handle device firmware loading,
>> > nor do you seem to mention in in the comments.
>>
>> Correct.
>>
>> > I believe signed firmware loading should be put on plate as well, right?
>>
>> I think that's definitely something that should be covered. I hadn't
>> worried about it immediately as any attack would be limited to machines
>> with a specific piece of hardware, and the attacker would need to expend
>> a significant amount of reverse engineering work on the firmware - and
>> we'd probably benefit from them doing that in the long run...
>
> Now -- how about resuming from S4?
>
> Reading stored memory image (potentially tampered before reboot) from disk
> is basically DMA-ing arbitrary data over the whole RAM. I am currently not
> able to imagine a scenario how this could be made "secure" (without
> storing private keys to sign the hibernation image on the machine itself
> which, well, doesn't sound secure either).

I have a patch that disables that.  I imagine it will be included in the
next submission of the patchset.

You can find it here in the meantime:

http://jwboyer.fedorapeople.org/pub/0001-hibernate-Disable-in-a-Secure-Boot-environment.patch

josh
