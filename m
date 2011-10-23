Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1JWCuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 22:50:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42660 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab1JWCuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 22:50:08 -0400
MIME-Version: 1.0
In-Reply-To: <CALKntY3Xo6R2zLs8oM=+=-VPdFXeLsdGi_YbMiA_1085xhMOQw@mail.gmail.com>
References: <CALKntY3Xo6R2zLs8oM=+=-VPdFXeLsdGi_YbMiA_1085xhMOQw@mail.gmail.com>
Date: Sun, 23 Oct 2011 10:50:08 +0800
Message-ID: <CAM_iQpU+xHww_JCYYA4kAKCXmOZpZeu=+rnCyRL-5dW5Uxk1hQ@mail.gmail.com>
Subject: Re: copy_*_user
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 1:06 AM, Xin Tong <xerox.time.tech@gmail.com> wrote:
> I am investigating copy_from_user  and copy_to_user in linux under
> i386. These two function both take a pointer with virtual address and
> a pointer with physical address.
>
> copy_from_user calls __copy_from_user_ll and copy_to_user  calls
> __copy_to_user_ll. It make sense to me that __copy_to_user_ll converts
> the virtual address to physical address using the current process's
> page table.
>
[...]
> But it seems to be that __copy_from_user_ll  is not converted the
> address at all before attempting to copy. Can someone help explain to
> me why ?
>

You missed that __copy_to_user_ll() only does that when CONFIG_X86_WP_WORKS_OK
is not defined. And there is a comment right inside __copy_to_user_ll() said:


               /*
                 * CPU does not honor the WP bit when writing
                 * from supervisory mode, and due to preemption or SMP,
                 * the page tables can change at any time.
                 * Do it manually.      Manfred <manfred@colorfullife.com>
                 */

this is why it uses kmap_atomic()+memcpy() to copy the data.

Also, all the addresses are virtual address.
