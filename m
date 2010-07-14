Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab0GNNXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0GNNXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:23:52 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CFQ: Don't store left slice when slice used up or for a idle workload
References: <4C3BCDA1.5040007@cn.fujitsu.com>
	<x49r5j7plwy.fsf@segfault.boston.devel.redhat.com>
	<4C3D0762.2060807@cn.fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 14 Jul 2010 09:23:40 -0400
In-Reply-To: <4C3D0762.2060807@cn.fujitsu.com> (Gui Jianfeng's message of
	"Wed, 14 Jul 2010 08:40:02 +0800")
Message-ID: <x49aapuci3n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng <guijianfeng@cn.fujitsu.com> writes:

> Jeff Moyer wrote:
>> Gui Jianfeng <guijianfeng@cn.fujitsu.com> writes:
>> 
>>> It doesn't make sence to store left time slice for an idle workload
>>> or for the cfqq that uses up its slice.
>> 
>> Did you actually observe any problems?  As I understand it, if you
>> overrun your slice you get a negative offset, so I think we want to keep
>> that.
>
> Hi Jeff
>
> If that's the case, do we also need to store the negative offset when slice
> used up in cfq_select_queue() and cfq_idle_slice_timer()?

Good question;  the code is inconsistent as it stands.

        /*
         * store what was left of this slice, if the queue idled/timed out
         */

If we are to believe that comment, then yes, we should also call
cfq_slice_expired with timed_out set to 1 in cfq_idle_slice_timer when
the slice is used, and for certain cases in select_queue.

I find this counter-intuitive, actually.  I would have stored residual
for quite the opposite situation: where you are preempted and so don't
get to run for your fair share.  But, there must be some
logic/experience behind the current mechanism....

Cheers,
Jeff
