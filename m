Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2CGKsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:48:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46726 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2CGKs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:48:29 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Barry Song" <Barry.Song@csr.com>, "Cong Wang" <xiyou.wangcong@gmail.com>
Cc: m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        "Barry Song" <Baohua.Song@csr.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper to
 test CMA
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
 <4F56E0AC.8070501@gmail.com>
Date: Wed, 07 Mar 2012 11:48:24 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wasqyyok3l0zgt@mpn-glaptop>
In-Reply-To: <4F56E0AC.8070501@gmail.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 03/07/2012 11:14 AM, Barry Song wrote:
>> Any write request to /dev/cma_test will let the module to allocate memory from
>> CMA, for example:
>>
>> 1st time
>> $ echo 1024>  /dev/cma_test
>> will require cma_test to request 1MB(1024KB)
>> 2nd time
>> $ echo 2048>  /dev/cma_test
>> will require cma_test to request 2MB(2048KB)
>>
>> Any read request to /dev/cma_test will let the module to free the 1st valid
>> memory from CMA, for example:
>>
>> 1st time
>> $ cat /dev/cma_test
>> will require cma_test to free the 1MB allocated in the first write request
>> 2nd time
>> $ cat /dev/cma_test
>> will require cma_test to free the 2MB allocated in the second write request

On Wed, 07 Mar 2012 05:14:36 +0100, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> Any reason why using /dev not /proc or /sys?

Because /proc is for processes and /sys is for stable, documented APIs.

If anything, debugfs might make some sense, but since the module needs struct
device anyway, it can just register a misc device, which is simpler and does
not require debugfs to be compiled.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
