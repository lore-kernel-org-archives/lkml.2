Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513Ab0KRWxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:53:42 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:49835 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab0KRWxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:53:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=
	mime-version:in-reply-to:references:date:message-id:subject:from
	:to:cc:content-type:content-transfer-encoding; q=dns; s=drama; b=
	b+AIjSRcp1qaLR00WWmOcH+mByZTGeJ/YPswhraAj/LcLIbwbOoUqKQdT7SQCBcl
	YPMWuHQIgd3fmHz0MulHyOSy+zrzYy3zKd/iQur+idetCjqRpRcyVusWG2gMyGb8
	9URqzT95O/EUVA1CEJ0bmnPmmcmOVJcc8L9KQFYhxLQ=
MIME-Version: 1.0
In-Reply-To: <20101118013002.GC8558@kroah.com>
References: <1289953929-30896-1-git-send-email-yehuda@hq.newdream.net>
	<20101117171924.GC12050@kroah.com>
	<AANLkTims_MjBS1SdHkOjOWvGqg1aRABH23MWk8J-E+-Y@mail.gmail.com>
	<20101118013002.GC8558@kroah.com>
Date: Thu, 18 Nov 2010 14:53:35 -0800
Message-ID: <AANLkTi=7z40CNBUmfVUEa68J+1R=7nbn9d8vM7ETpajA@mail.gmail.com>
Subject: Re: [PATCH] rbd: replace the rbd sysfs interface
From: Yehuda Sadeh Weinraub <yehuda@hq.newdream.net>
To: Greg KH <greg@kroah.com>
Cc: sage@newdream.net, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 5:30 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Nov 17, 2010 at 03:00:17PM -0800, Yehuda Sadeh Weinraub wrote:
>> On Wed, Nov 17, 2010 at 9:19 AM, Greg KH <greg@kroah.com> wrote:
>> > On Tue, Nov 16, 2010 at 04:32:09PM -0800, Yehuda Sadeh wrote:
>> >> Hi Greg,
>> >>
>> >> Following is the new rbd sysfs interface. It lists devices in their own
>> >> subdirectories, as well as their underlying snapshots. Please let us
>> >> know if there's any issue you think we missed or did wrong.
>> >>
>> >> Thanks,
>> >> Yehuda
>> >>
>> >> ---
>> >>
>> >> The new interface creates directories per mapped image
>> >> and under each it creates a subdir per available snapshot.
>> >> This allows keeping a cleaner interface within the sysfs
>> >> guidelines. The ABI documentation was updated too.
>> >>
>> >> Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
>> >> ---
>> >> ?Documentation/ABI/testing/sysfs-class-rbd | ? 83 +++
>> >> ?drivers/block/rbd.c ? ? ? ? ? ? ? ? ? ? ? | ?775 +++++++++++++++++------------
>> >> ?2 files changed, 547 insertions(+), 311 deletions(-)
>> >>
>> >> diff --git a/Documentation/ABI/testing/sysfs-class-rbd b/Documentation/ABI/testing/sysfs-class-rbd
>> >> new file mode 100644
>> >> index 0000000..4d96618
>> >> --- /dev/null
>> >> +++ b/Documentation/ABI/testing/sysfs-class-rbd
>> >> @@ -0,0 +1,83 @@
>> >> +What: ? ? ? ? ? ? ? ?/sys/class/rbd/
>> >
>> > I thought I mentioned that you should not add new classes to the kernel.
>> > Please don't do that, make it a bus_type instead.
>>
>>
>> Ahmm.. apparently not in the rbd related threads. So moving things
>> around and having rbd under /sys/bus we'll have the following:
>>
>> /sys/bus/rbd/drivers/rbd/..
>>     add - add a device
>>     remove - remove a device
>
> These files could go in /sys/bus/rbd/ directly instead of burying under
> 2 more layers, right?
>
>>
>> /sys/bus/rbd/devices/<id>
>>    name
>>    pool
>>    ...
>>
>> /sys/bus/rbd/devices/<id>/snaps/<name>
>>     id
>>     size
>>     ...
>>
>>
>> Would this work?
>
> With the change mentioned above, I think that seems sane, do you?
>

Yes, pretty much. One problem that I do see is that if we define the
snaps/ as a device (and not just as a kobj) as you suggested before,
it'll automatically create a 'uevent' entry under it which can be a
real issue in the case we have a snapshot named like that. Shouldn't
we just create it as a kobj in that case?

Thanks,
Yehuda
