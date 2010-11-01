Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0KANlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:41:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45326 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab0KANlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=urx5Jc5hi+nUMkfi49wX1XURvI4nN1fWmxMs4SjUFzjD5VCukwHOWzfQDblkLEsvJm
         dnqkbL2LqSFVjPuJOvLkqQKZlDoiGndsplCGvdlnvyN8al0ywsVuV2N6crzkbNSPq3E4
         y0PSNqW027Vl5SX2OF9o02mS89qum3I+47WVA=
MIME-Version: 1.0
In-Reply-To: <20101101130842.GA24605@Krystal>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>
	<20101030214704.GA20005@Krystal>
	<4CCEB723.2010005@kernel.dk>
	<20101101130842.GA24605@Krystal>
Date: Mon, 1 Nov 2010 15:41:06 +0200
X-Google-Sender-Auth: g1pD8ZlgDAcgUOO3XFtkzpwlTYc
Message-ID: <AANLkTinZaSchq6UKUkiaFTrmdHMpY7x4uN886r7iXeYU@mail.gmail.com>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
From: Pekka Enberg <penberg@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (axboe@kernel.dk) wrote:
>> On 2010-10-30 17:47, Mathieu Desnoyers wrote:
>> > BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
>> > transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
>> > relay dependency to the Generic Ring Buffer Library might be a good
>> > option to consider.
>>
>> The blktrace user bits is still (by far) the most wide spread way that
>> blktrace is used in the field, and those still rely on relayfs. So no,
>> we can't kill it now.

On Mon, Nov 1, 2010 at 3:08 PM, Mathieu Desnoyers
<mathieu.desnoyers@polymtl.ca> wrote:
> What I am proposing is that the Generic Ring Buffer Library could
> replace relayfs without changing any of the interfaces blktrace exposes
> to user-space. Indeed, I would not remove relayfs unless there was a
> replacement.

We don't in general NAK cleanups because of future features or
removals that may or may not happen.
