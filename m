Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1G0OZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:25:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab1G0OZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:25:22 -0400
Message-ID: <4E301FCD.6060202@redhat.com>
Date: Wed, 27 Jul 2011 10:25:17 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write
 devices
References: <1311764491-5687-1-git-send-email-apw@canonical.com>
In-Reply-To: <1311764491-5687-1-git-send-email-apw@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 07:01 AM, Andy Whitcroft wrote:
> When we mount a btrfs filesystem from read-only media there will be no
> read/write devices; for example mounting an SD card with its lock enabled.
> This triggers an immediate BUG during mount:
> 
>   kernel BUG at .../fs/btrfs/super.c:984!
> 
> This is triggered by statfs when calculating the free space in the
> filesytem.  We bug if the number of read/write devices is 0.
> 
> It seems more appropriate to indicate we have no writable space.  Note
> that this does make df return 0 free blocks on a read-only device.
> Whether that is reasonable is debatable.

No it's not, it's wrong.  We should just look at the devices in general
and not just the rw_devices.  We can still get the right info out, if
you mount a ext* fs ro you still get the right output from df.  Thanks,

Josef
