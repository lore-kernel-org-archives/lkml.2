Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1E0RJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:09:33 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:62403 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab1E0RJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BenezLer921IBaIW7YY+28kOuSNdrNz4S7YtGFryuj1AOraM/tKt7tzeCVirNaz2lh
         IBNPVaJ51MetM0CYHgdLqoVEbeFiNdIC1XRL5iOCVQoQq3OQYgNDxk3bu43TJM7qJ5it
         wn703zg+eThJ0PlhxkAqNs0YjiHmpWm2L4uT8=
MIME-Version: 1.0
In-Reply-To: <20110527164702.GB28520@samba2>
References: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
	<20110527164702.GB28520@samba2>
Date: Fri, 27 May 2011 12:09:30 -0500
Message-ID: <BANLkTikCUy-R16_QhuwNtynP9mXd9zFDNQ@mail.gmail.com>
Subject: Re: Big performance improvements seen with cifs async write patches
 even over localhost
From: Steve French <smfrench@gmail.com>
To: Jeremy Allison <jra@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:47 AM, Jeremy Allison <jra@samba.org> wrote:
> On Fri, May 27, 2011 at 12:14:19AM -0500, Steve French wrote:
>> Did some informal testing of Jeff Layton's cifs async_write patch set
>> tonight (recent kernel). Copying 700MB sequentially was 20% faster
>> from cifs kernel client to Samba 3.6 with his patches - even mounted
>> over localhost (where network latency is a much smaller issue) and
>> with a slow laptop drive!
>>
>> I was simply doing
>>
>> time dd if=/dev/zero of=/mnt/null bs=1M count=700
>>
>> repeated 4 times each way (with old module, and with same code with
>> Jeff's cifs async write code builtin), deleting the target file in
>> between each run.
>>
>> I am looking forward to trying this over GigE tomorrow to servers with
>> faster disks.

Note that Samba defaults to negotiating a 128K write size but sending
"min receivefile size" in smb.conf to a larger value will allow larger
writes.   I see slightly better performance on the simple dd test over
localhost network interface with larger wsize of 512K than I do with
the default (128K).   I haven't measured the ideal wsize yet but
presumably it will vary depending on network and disk speed and server
load.

> Very nice ! Now where's my encrypted transport Steve ? :-) :-)

First cleanup patch is in (which gracefully handles failing mounts
when server requires encryption and client can't do it).    The 2nd
part - the NTLMSSP negotiation inside setfsunixinfo wasn't too bad and
I plan to send out for review within a few days.  I haven't written
the piece which uses these credentials to do the encryption yet.



-- 
Thanks,

Steve
