Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0LBGwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:52:49 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41120 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab0LBGws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:52:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AcTBi8ceabL79lrgst5If5A3nyRKE2qDIWLsYp6FTRKf/aFn5p7ii8P1lMfTuz3Xw3
         d0PAQwaU1YAq/ANop7xDipFxaVAb68T1rs4hV41C9b32wHr+07K6zcyEeUpHv0GTWd8G
         ETLyrPPlGhIN7sMe16ChahdNhl8aJJ2N1ZqCg=
Date: Thu, 2 Dec 2010 14:57:35 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Bennee <kernel-hacker@bennee.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] flex_array: export symbols to modules
Message-ID: <20101202065735.GE5196@cr0.nay.redhat.com>
References: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com>
 <alpine.DEB.2.00.1012011714510.22420@chino.kir.corp.google.com>
 <20101202063054.GB3367@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202063054.GB3367@linux-sh.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 03:30:55PM +0900, Paul Mundt wrote:
>On Wed, Dec 01, 2010 at 05:16:05PM -0800, David Rientjes wrote:
>> On Wed, 1 Dec 2010, Alex Bennee wrote:
>> > I want to be able to use the flex_array functions in my module so I
>> > wanted to EXPORT_SYMBOL the API.
>> > 
>> > I added the appropriate EXPORT_SYMBOL runes into lib/flex_array.c and
>> > added externs in the header files but after re-building there is still
>> > no sign of them in Module.symvers.
>> 
>> You shouldn't need to add any externs in include/linux/flex_array.h, they 
>> should already be publically declared.
>> 
>> Perhaps you forgot to include linux/module.h in lib/flex_array.c?
>> 
>> flex_array: export symbols to modules
>> 
>> Add EXPORT_SYMBOL() for all publically accessible flex array functions.
>> 
>> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
>> Signed-off-by: David Rientjes <rientjes@google.com>
>> ---
>>  lib/flex_array.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>> 
>This will be ineffective so long as flex_array.o remains lib-y. It will
>need to be moved to obj-y if modules are to also make use of it.

Not moved, it needs to be added to obj-y.
