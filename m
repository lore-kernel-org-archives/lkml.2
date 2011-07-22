Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1GVNDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:03:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41983 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab1GVNDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110722121302.GB9732@redhat.com>
References: <1311195386-22743-1-git-send-email-dzickus@redhat.com>
	<4E277584.1060200@intel.com>
	<20110721122731.GV3765@redhat.com>
	<987664A83D2D224EAE907B061CE93D5301E9EC9DC6@orsmsx505.amr.corp.intel.com>
	<4E28C552.8060803@intel.com>
	<20110722121302.GB9732@redhat.com>
Date: Fri, 22 Jul 2011 21:03:42 +0800
Message-ID: <CAC=cRTPz1vw14GXCWwuP-d4z_R77Vi_UQufgwR5Syx6RAzvYUg@mail.gmail.com>
Subject: Re: [PATCH] pstore: change mutex locking to spin_locks
From: huang ying <huang.ying.caritas@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 8:13 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Jul 22, 2011 at 08:33:22AM +0800, Huang Ying wrote:
>> On 07/22/2011 01:57 AM, Luck, Tony wrote:
>> >>> Is it safe to call pstore_mkfile with IRQ disabled?
>> >>>
>> >>> pstore_mkfile -> d_alloc_name -> d_alloc -> kmem_cache_alloc(, GFP_KERNEL).
>> >>
>> >> Don't know.  But would that mean we would have to put the pstore_mkfile
>> >> on a workqueue then or something similar?
>> >
>> > That might be a good idea anyway.  In the "oops" case we'd like the file
>> > to appear in the pstore filesystem if the system stayed healthy despite
>> > the oops[1]. There isn't any reason why the pstore entry must appear instantly.
>> > Delaying the creation would avoid running into problems related to the
>> > oops.
>>
>> For oops, it may be better to delay writing into something like
>> workqueue.  But for panic, I think we should write the record to backend
>> (such as ERST) as soon as possible.  So maybe it is better to write to
>> backend as soon as possible and delay writing to pstore filesystem.
>
> In the panic case do we care if the pstore fs is mounted (which leads us
> to run pstore_mkfile)?
>
> Actually it seems like most of the entry points into pstore_dumper would
> not require the fs to create a new file.  I think the exception is an
> oops.

Yes.  I think so too.

Best Regards,
Huang Ying
