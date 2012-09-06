Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2IFLbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:31:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59232 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2IFLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:31:50 -0400
Message-ID: <504889A1.2090507@gmail.com>
Date: Thu, 06 Sep 2012 07:31:45 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Ping^3] Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without
 CAP_SYS_RAWIO
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <50195108.1090105@redhat.com> <503CA5BA.2040003@redhat.com> <50476480.9010302@redhat.com> <5047B38D.9000607@gmail.com> <50484345.8040508@redhat.com>
In-Reply-To: <50484345.8040508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 02:31 AM, Paolo Bonzini wrote:
> Il 05/09/2012 22:18, Ric Wheeler ha scritto:
>> Hi Paolo,
>>
>> Both of these commands are destructive. WRITE_SAME (if done without the
>> discard bits set) can also take a very long time to be destructive and
>> tie up the storage.
> FORMAT_UNIT has the same characteristics and yet it is allowed (btw, I
> don't think WRITE SAME slowness is limited to the case where a real
> write is requested; discarding can be just as slow).
>
> Also, the two new commands are anyway restricted to programs that have
> write access to the disk.  If you have read-only access, you won't be
> able to issue any destructive command (there is one exception, START
> STOP UNIT is allowed even with read-only capability and is somewhat
> destructive).
>
> Honestly, the only reason why these two commands weren't included, is
> that the current whitelist is heavily tailored towards CD/DVD burning.

Hi Paolo,

I assume that FORMAT_UNIT is for CD/DVD needs - not sure what a S-ATA disk would 
do with that. If it is destructive, we should probably think about how to make 
it more secure and see how many applications we would break.

>
>> I think that restricting them to CAP_SYS_RAWIO seems reasonable - better
>> to vet and give the appropriate apps the needed capability than to
>> widely open up the safety check?
> CAP_SYS_RAWIO is so wide in its scope, that anything that requires it is
> insecure.
>
> Paolo

I don't see allowing anyone who can open the device to zero the data as better 
though :)

Ric



