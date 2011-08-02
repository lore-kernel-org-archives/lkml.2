Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1HBVt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:49:56 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39837 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab1HBVtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110802174337.70a4ff15@tlielax.poochiereds.net>
References: <CAPwCz79UntBiAs4X+XSj62xvkpK0CW6cqQqhyCU97r4u5SmJ_g@mail.gmail.com>
	<20110802064455.0777c0fd@corrin.poochiereds.net>
	<20110802120008.3e19d193@tlielax.poochiereds.net>
	<CAH2r5mvTtsDVaYWYswo+CgFRRZJ-+hWTca-3V9vZP7wh0ezfyw@mail.gmail.com>
	<20110802174337.70a4ff15@tlielax.poochiereds.net>
Date: Tue, 2 Aug 2011 16:49:49 -0500
Message-ID: <CAH2r5mu9POJmnXPQSq9cnXJU05oW0bn71+Y3Oo0YPB_uhz1cKQ@mail.gmail.com>
Subject: Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Jan Seiffert <kaffeemonster@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sfrench@us.ibm.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

your explanation makes sense.  will revert the commit unless anyone objects.

On Tue, Aug 2, 2011 at 4:43 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Tue, 2 Aug 2011 11:03:28 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> your patch does look right.
>>
>
> Sigh...as is often the case, things are not quite so simple...
>
> I did some auditing of how server->maxBuf is used in the cifs code and
> found it to be very confused. The reason it basically works, I think is
> because on NEGOTIATE, the client does this:
>
>       server->maxBuf = min(le32_to_cpu(pSMBr->MaxBufferSize),
>                       (__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
>
> So using maxBuf and CIFSMaxBufSize interchangeably like the code does
> is basically OK, even if it is confusing to limit how much the client
> can receive based on how much the server can.
>
> I think that we really need to approach this more comprehensively and
> have a clear delineation between server->maxBuf and CIFSMaxBufSize. I
> don't think it would be wise though to put that into 3.1 at this point.
>
> I think it would probably be best to just back out commit c4d3396b2 for
> now, and I'll plan to do this as a larger (and hopefully better-tested)
> patchset for 6.2.
>
> Sound ok? Do you need me to send a revert patch?
>
> --
> Jeff Layton <jlayton@redhat.com>
>



-- 
Thanks,

Steve
