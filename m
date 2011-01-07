Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1AGQpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:45:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43066 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab1AGQpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:45:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dIS8YhQLcFO53k+DqOTSy9j7pqVZe5xsJUTtqCxKxj9RzA1+6J7SBdt1glxYeUK32a
         iYJG0UMYW75I8HCDXIAVELvlEaEOZK2b7dITrPkM+dDh52ovEzozGPoSgq2pz0u7psmk
         1W1eM4VDrw5NSYMIhktkajPz134i/qqFI/yHU=
MIME-Version: 1.0
In-Reply-To: <4D27319A.3060806@kernel.dk>
References: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
	<4D26CCEE.4070508@kernel.dk>
	<AANLkTingF8jK2Lppng+MCeszB=KFEsqs9uRqBn0Uhdh8@mail.gmail.com>
	<4D2710DC.9050908@kernel.dk>
	<AANLkTi=ZV4-vb7qEbGn=mm6Nz0Jg=XT5YogD=0HNTSdW@mail.gmail.com>
	<4D27319A.3060806@kernel.dk>
Date: Fri, 7 Jan 2011 11:45:43 -0500
Message-ID: <AANLkTinmkAhCVOnF+x=Azfypg6Faadq=rn+Wuk+UdUJD@mail.gmail.com>
Subject: Re: Who does determine the number of requests that can be serving
 simultaneously in a storage?
From: Yuehai Xu <yuehaixu@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, cmm@us.ibm.com, rwheeler@redhat.com,
        vgoyal@redhat.com, czoccolo@gmail.com, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You don't need those values. btt can just look at dispatch and
> completion events to get an exact queue depth number at any point in
> time.

Cool tool, I need to learn it further.

> I would double check that NCQ really is active, not just supported. For
> instance, the controller needs to support it too. If you look at dmesg
> from when it detects your drive, it should print the queue depth used.
> Or you can check queue_depth in the sysfs scsi_device directory. It
> should be 31 (32 in total, but one has to be reserved for error
> handling) for NCQ enabled, or 1 if if isn't.
>

You are right, info from dmesg:
[    1.476660] ata4.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 0/32)

and queue_depth is 1.

It proves that the NCQ of SSD is not actually activated. Error
message(bash: /sys/block/sdb/device/queue_depth: Permission denied) is
got when I "echo 31 > /sys/block/sdb/device/queue_depth" even though I
am already with the privilege of root.

Anyway, one thing is certain, it is because the NCQ of SSD is not
activated, that the number of requests in flight is 1.

I really appreciate your help, thanks very much!

Yuehai
