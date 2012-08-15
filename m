Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2HOR6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:58:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53571 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2HOR6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <502B8D1F.7030706@anonymous.org.uk>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
 <502B8D1F.7030706@anonymous.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Aug 2012 10:57:40 -0700
Message-ID: <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
Subject: Re: O_DIRECT to md raid 6 is slow
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 4:50 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 15/08/2012 01:49, Andy Lutomirski wrote:
>>
>> If I do:
>> # dd if=/dev/zero of=/dev/md0p1 bs=8M
>
> [...]
>
>> It looks like md isn't recognizing that I'm writing whole stripes when
>> I'm in O_DIRECT mode.
>
>
> I see your md device is partitioned. Is the partition itself stripe-aligned?

Crud.

md0 : active raid6 sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
      11720536064 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/6] [UUUUUU]

IIUC this means that I/O should be aligned on 2MB boundaries (512k
chunk * 4 non-parity disks).  gdisk put my partition on a 2048 sector
(i.e. 1MB) boundary.

Sadly, /sys/block/md0/md0p1/alignment_offset reports 0 (instead of 1MB).

Fixing this has no effect, though.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
