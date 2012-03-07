Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2CGK4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:56:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2CGK4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:56:07 -0500
MIME-Version: 1.0
In-Reply-To: <op.wasqyyok3l0zgt@mpn-glaptop>
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
 <4F56E0AC.8070501@gmail.com> <op.wasqyyok3l0zgt@mpn-glaptop>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 7 Mar 2012 18:55:46 +0800
Message-ID: <CAGsJ_4wb3yMwSVW8ppvMoFe-oJXvNYigttg9S_kAVnDkDhDGHg@mail.gmail.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper to
 test CMA
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Barry Song <Barry.Song@csr.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/7 Michal Nazarewicz <mina86@mina86.com>:
>> On 03/07/2012 11:14 AM, Barry Song wrote:
>>>
>>> Any write request to /dev/cma_test will let the module to allocate memory
>>> from
>>> CMA, for example:
>>>
>>> 1st time
>>> $ echo 1024>  /dev/cma_test
>>> will require cma_test to request 1MB(1024KB)
>>> 2nd time
>>> $ echo 2048>  /dev/cma_test
>>> will require cma_test to request 2MB(2048KB)
>>>
>>> Any read request to /dev/cma_test will let the module to free the 1st
>>> valid
>>> memory from CMA, for example:
>>>
>>> 1st time
>>> $ cat /dev/cma_test
>>> will require cma_test to free the 1MB allocated in the first write
>>> request
>>> 2nd time
>>> $ cat /dev/cma_test
>>> will require cma_test to free the 2MB allocated in the second write
>>> request
>
>
> On Wed, 07 Mar 2012 05:14:36 +0100, Cong Wang <xiyou.wangcong@gmail.com>
> wrote:
>>
>> Any reason why using /dev not /proc or /sys?
>
>
> Because /proc is for processes and /sys is for stable, documented APIs.
>
> If anything, debugfs might make some sense, but since the module needs
> struct
> device anyway, it can just register a misc device, which is simpler and does
> not require debugfs to be compiled.

Michal, thanks for clarification. actually after i sent my mail to
agree Cong's /proc might be ok, then i had more thinking, i came back
to think the original /dev is better since anyway we need to device to
alloc CM.
then we let the device's read/write to handle alloc/free. it is much
more direct for a test module.

>
> --
> Best regards,                                         _     _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
>

-barry
