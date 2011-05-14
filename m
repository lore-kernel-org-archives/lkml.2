Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759794Ab1ENA4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 20:56:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41360 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1ENA4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 20:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uvKhqMFq4P08BzqGVzXiNHptKH/GzItZEAZ18u1wIIeuu9Db0GLrjSoxzKFH1ILs65
         k/m36LPfYrDvwm/aHPhjb/cZXfVjwv2U9+lLaBOX/BZ6RFmE3IdO1sxxAYtJXlUPcI3A
         oLmXVSXCXdMlfL8YOPQDHi6f6FU1qvOSXX8Ls=
MIME-Version: 1.0
In-Reply-To: <20110513152033.GB3854@elte.hu>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
	<20110513124523.GM13984@redhat.com>
	<20110513130011.GA6474@elte.hu>
	<BANLkTi=Z_3MZVs2CQyk82NfvZj-KdSw5kw@mail.gmail.com>
	<20110513152033.GB3854@elte.hu>
Date: Sat, 14 May 2011 08:56:29 +0800
Message-ID: <BANLkTik-VBBJtv_fGBAbNEXgX15zJmTYfA@mail.gmail.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * huang ying <huang.ying.caritas@gmail.com> wrote:
>
>> > What should be done instead is to add an event for unknown NMIs, which can
>> > then be processed by the RAS daemon to implement policy.
>> >
>> > By using 'active' event filters it could even be set on a system to panic
>> > the box by default.
>>
>> If there is real fatal hardware error, maybe we have no luxury to go from NMI
>> handler to user space RAS daemon to determine what to do. System may explode,
>> bad data may go to disk before that.
>
> That is why i suggested:
>
>  > > By using 'active' event filters it could even be set on a system to panic
>  > > the box by default.
>
> event filters are evaluated in the kernel, so the panic could be instantaneous,
> without the event having to reach user-space.

Yes.  If we do that in kernel, that should be doable.

Does 'active' event filters have much difference with DIE_UNKNOWNNMI
notifier chain?  What can we get from the added complexity?  What do
you think is the better way to determine go panic on unknown NMI or
not?

Best Regards,
Huang Ying
