Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1LUTUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:20:54 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33008 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751683Ab1LUTUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:20:50 -0500
Message-ID: <4EF23FA4.7080507@xenotime.net>
Date: Wed, 21 Dec 2011 12:20:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Samuel Ortiz <samuel@sortiz.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 19 (nfc)
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au> <4EEFA21B.5010305@xenotime.net> <1324399181.5354.0.camel@sortiz-mobl> <4EF23A1F.60803@xenotime.net> <20111221190211.GE11842@tuxdriver.com>
In-Reply-To: <20111221190211.GE11842@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 11:02 AM, John W. Linville wrote:
> On Wed, Dec 21, 2011 at 11:57:19AM -0800, Randy Dunlap wrote:
>> On 12/20/2011 08:39 AM, Samuel Ortiz wrote:
>>> Hi Randy,
>>>
>>> On Mon, 2011-12-19 at 12:44 -0800, Randy Dunlap wrote:
>>>> On 12/18/2011 11:55 PM, Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Changes since 20111216:
>>>>
>>>>
>>>> (not new today, just not reported earlier)
>>> John applied my fix for this one. It should be fixed now.
>>
>> Hi Samuel,
>>
>> Is this supposed to be fixed in linux-next?
>> It still fails today (linux-next 20111221).
>>
>>
>> data.c:(.text+0x3e0): multiple definition of `nfc_llcp_mac_is_down'
>> data.c:(.text+0x400): multiple definition of `nfc_llcp_mac_is_up'
>> ntf.c:(.text+0xb60): multiple definition of `nfc_llcp_mac_is_down'
>> ntf.c:(.text+0xb80): multiple definition of `nfc_llcp_mac_is_up'
>> rsp.c:(.text+0x750): multiple definition of `nfc_llcp_mac_is_down'
>> rsp.c:(.text+0x770): multiple definition of `nfc_llcp_mac_is_up'
>> netlink.c:(.text+0x14e0): multiple definition of `nfc_llcp_mac_is_down'
>> netlink.c:(.text+0x1500): multiple definition of `nfc_llcp_mac_is_up'
>> af_nfc.c:(.text+0xe0): multiple definition of `nfc_llcp_mac_is_down'
>> af_nfc.c:(.text+0x100): multiple definition of `nfc_llcp_mac_is_up'
>> rawsock.c:(.text+0x1000): multiple definition of `nfc_llcp_mac_is_down'
>> rawsock.c:(.text+0x1020): multiple definition of `nfc_llcp_mac_is_up'
> 
> I have this commit in wireless-next, been there a couple of days:

Apparently this patch is not sufficient.  There is still a build problem.


> commit 645d35902c8f05a1b12fa838aa9052d8eeaf161e
> Author: Samuel Ortiz <sameo@linux.intel.com>
> Date:   Fri Dec 16 15:03:36 2011 +0100
> 
>     NFC: Fix LLCP related build failure
>     
>     llcp_mac routines should be static and inlined or build will fail with NFC
>     selected without LLCP.
>     
>     This patch fixes:
>     
>     LD [M]  net/nfc/nfc.o
>     net/nfc/netlink.o: In function `nfc_llcp_mac_is_down':
>     netlink.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
>     net/nfc/core.o:(.text+0x0): first defined here
>     net/nfc/netlink.o: In function `nfc_llcp_mac_is_up':
>     netlink.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
>     net/nfc/core.o:(.text+0x10): first defined here
>     net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_down':
>     (.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
>     net/nfc/core.o:(.text+0x0): first defined here
>     net/nfc/af_nfc.o: In function `nfc_llcp_mac_is_up':
>     (.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
>     net/nfc/core.o:(.text+0x10): first defined here
>     net/nfc/rawsock.o: In function `nfc_llcp_mac_is_down':
>     rawsock.c:(.text+0x0): multiple definition of `nfc_llcp_mac_is_down'
>     net/nfc/core.o:(.text+0x0): first defined here
>     net/nfc/rawsock.o: In function `nfc_llcp_mac_is_up':
>     rawsock.c:(.text+0x10): multiple definition of `nfc_llcp_mac_is_up'
>     net/nfc/core.o:(.text+0x10): first defined here
>     
>     Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
