Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0LHT4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:56:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58557 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab0LHT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:56:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cgB9jcOFp8FqE5VU/tzdrfXm1fjwKCL0e2zhN3p48nKxV8/MD/Lhcy2fP+03M5+x6y
         gfUmdXSWqtHYvlCtraBbjqKBNmXtVFG4yk4rY/7ndg6boHHaMejkwjB/ywXuQzCnIXGD
         dSRmxZxPikOWbYRRQdjmqcwC7IzUTnWIN55OY=
Message-ID: <4CFFE2EA.9040909@gmail.com>
Date: Wed, 08 Dec 2010 14:56:26 -0500
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Christian Brandt <brandtc@psi5.com>
CC: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: swap storage alignment and stride size
References: <4CFFBA7D.6060802@psi5.com>
In-Reply-To: <4CFFBA7D.6060802@psi5.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 12:03 PM, Christian Brandt wrote:
> Preamble:
>
> Hi fellow linux tamers, the following question has bounced around for
> some days in local lists and newsgroups without conclussion and was
> escalated upstream several times, here we are...
>
> We are discussing semi-professional storage systems, e.g. ext4 on luks
> on lvm on raid on gpt-partitions on 4k sector harddrives or 512k sector
> SSDs. Usually every level profits a lot from aligning the data to the
> underlying sector/stride/chunk size, e.g. ext4 with a 128k stripe size
> will run a lot better on a well aligned 64k stride raid5.
>
> In other words, partition tables, LVM, RAID, luks and filesystems know
> how to handle and profit from aligned larger chunks.
>
> In detail:
>
> As far as we can read mm/swapfile.c linux is only concerned about cpu
> page size and does not know anything about underlying
> chunk/sector/stride sizes and alignment.
>
> Therefore we think every small 1/2/4/8kiB page-sized write access leads
> to a read-modify-write cycle for the whole chunk, taking more then twice
> as long than simply writing the whole chunk at once.
>
> Questions:
>
> Is this the right place to ask?
>
> Does or could linux swapping make use of aligning chunks?
>
> And if, how?
>
> If not, would it be an improvement?
>
> Will this effect be mostly compensated by the block elevator?
>
> Does it make any sense to change the mkswap page size to the chunk size?
> We think those are two totally different beasts and should be left
> seperated.
>
> Is Linux already aware of chunk sizes within swap?
>
> How to set up and controlled by the administrator?
>

Hi Christian,

There has been a lot of work on alignment, Martin Petersen lead most of that and 
is probably the best one to ping.

Ric


