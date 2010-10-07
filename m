Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab0JGDq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:46:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49328 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0JGDqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jf/gaFsBTMeExaNe4VaLEKLTsuoNDlqJzVwkLvP8JalWVTxKeUA3VbVlYM7NujLy5n
         iq6Y5YFZ1y7FaHMsMjIYcuVAYKE3w4wtxpX/gC8hjvZzt8sf7Ea0Kn4NswW0u9Gsm18d
         9XujisauRV1gMq6LvffPBLcAPLbCTy6K/5trE=
MIME-Version: 1.0
In-Reply-To: <1286422706.2468.1.camel@nisroch>
References: <AANLkTikBXb-QZ2twFUZHzzYSHyZz1Kca4GRLu_6bo+Oo@mail.gmail.com>
	<1286324509.2505.0.camel@clockmaker-el6>
	<AANLkTimR4JYmA4n0kGZ+mHqEfNUrxoLMAC6hW6s4-YhF@mail.gmail.com>
	<1286422706.2468.1.camel@nisroch>
Date: Wed, 6 Oct 2010 23:46:24 -0400
Message-ID: <AANLkTikocY=xaNWHTV5YbRCj1Y2Nn7GH=i0HksjKnyZS@mail.gmail.com>
Subject: Re: System freeze on shutdown - bisected to commit 29d08b3efddc
From: Marc Dionne <marc.c.dionne@gmail.com>
To: skeggsb@gmail.com
Cc: Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 11:38 PM, Ben Skeggs <skeggsb@gmail.com> wrote:
> v       gOn Wed, 2010-10-06 at 23:29 -0400, Marc Dionne wrote:
>> On Tue, Oct 5, 2010 at 8:21 PM, Dave Airlie <airlied@redhat.com> wrote:
>> > On Tue, 2010-10-05 at 18:24 -0400, Marc Dionne wrote:
>> >> Hi,
>> >>
>> >> My system has been crashing these past few days when issuing "reboot"
>> >> or hitting the Shut Down button in gnome.  I get a series of stack
>> >> traces scrolling on the console before things freeze up completely.
>> >> The traces that I do see at the end point to kmem_cache_alloc called
>> >> from get_empty_filp, but there are typically various other traces
>> >> above it.
>> >
>> > cc'ing Ben.
>> >
>> > Dave.
>>
>> Some more testing shows that what causes the crash is when
>> drm_gem_object_unreference_unlocked gets called in
>> nouveau_notifier_takedown_channel.  The refcount on the object is
>> always 1 at that point - on entry to nouveau_notifier_takedown I see a
>> handle_count of 0 and a refcount of 1 in most cases, and sometimes a
>> handle_count of 1 and a refcount of 2.  Either way the call to
>> drm_gem_object_unreference_unlocked will bring the refcount to 0.
>> Not sure if that's normal at that point.
>>
>> Commenting out that particular call to
>> drm_gem_object_unreference_unlocked gets rid of the crash.
> How about if you remove the drm_get_object_handle_unreference_unlocked()
> call from that function instead?
>
> Ben.

I had tested that earlier and just retested it now, and yes it also
cures the crash.

Marc
