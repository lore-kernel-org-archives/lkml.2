Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab0D3RXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:23:22 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49286 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525Ab0D3RWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-url:x-pgp-fp:x-pgp:date
         :in-reply-to:message-id:user-agent:mime-version:content-type;
        b=YS4ud9ixsYKZpWvR8lU2J56Y60E/8pN57vUQu7tKhNlAImHSrNd4g+nE48OFBxU5IR
         y7CoqnpyOM1oKXzXwiEgvU6qPVvXVbvK00WJjw3SvdqG/CLFAy0zTPFNiHUI6xfE/Q/V
         12b9oNwsL3NYsou+cLqs6+Q1kWgmpgvLfJGzM=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg KH <greg@kroah.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-usb@vger.kernel.org,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/8] USB: gadget: __init and __exit tags removed
References: <cover.1270835924.git.mina86@mina86.com>
	<3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
	<e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
	<aa83c43874f8aa490300d6bd03472646f2727eb1.1270835924.git.mina86@mina86.com>
	<20100429221529.GA16465@kroah.com>
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Thu, 29 Apr 2010 16:02:55 -0700 (PDT)
In-Reply-To: <20100429221529.GA16465@kroah.com> (Greg KH's message of "Thu, 29
	Apr 2010 15:15:29 -0700")
Message-ID: <87hbmtq2ua.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Fri, Apr 09, 2010 at 09:21:20PM +0200, Michal Nazarewicz wrote:
>> __init, __initdata and __exit tags have have been removed from
>> various files to make it possible for gadgets that do not use
>> the __init/__exit tags to use those.
>> 
>> Files in question are related to:
>> * the core composite framework,
>> * the mass storage function (fixing a section mismatch) and
>> * ethernet driver (ACM, ECM, RNDIS).
>> 
>> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  drivers/usb/gadget/composite.c      |   21 ++++++++++-----------
>>  drivers/usb/gadget/config.c         |    4 ++--
>>  drivers/usb/gadget/epautoconf.c     |   12 ++++++------
>>  drivers/usb/gadget/f_acm.c          |   32 ++++++++++++++++----------------
>>  drivers/usb/gadget/f_ecm.c          |   33 +++++++++++++++++----------------
>>  drivers/usb/gadget/f_mass_storage.c |    2 +-
>>  drivers/usb/gadget/f_rndis.c        |   34 ++++++++++++++++++----------------
>>  drivers/usb/gadget/u_ether.c        |    4 ++--
>>  8 files changed, 72 insertions(+), 70 deletions(-)
>> 
>> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>> index 09289bb..ff155ca 100644
>> --- a/drivers/usb/gadget/composite.c
>> +++ b/drivers/usb/gadget/composite.c
>> @@ -85,7 +85,7 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
>>   * This function returns the value of the function's bind(), which is
>>   * zero for success else a negative errno value.
>>   */
>> -int __init usb_add_function(struct usb_configuration *config,
>> +int __cold usb_add_function(struct usb_configuration *config,
>
> What is the "__cold" for?

__init, among other things implies __cold:

include/linux/init.h:43: #define __init   __section(.init.text) __cold notrace

and so I left __cold leaving out __section.

-- 
Pozdrawiam                                            _     _
 .o. | Wasal Jasnie Oswieconej Pani Informatyki     o' \,=./ `o
 ..o | Michal "mina86" Nazarewicz  <mina86*tlen.pl>    (o o)
 ooo +---<jid:mina86-jabber.org>---<tlen:mina86>---ooO--(_)--Ooo--
