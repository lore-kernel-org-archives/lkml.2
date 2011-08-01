Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1HAPYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1HAPYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:24:37 -0400
Message-ID: <4E36C530.5030003@redhat.com>
Date: Mon, 01 Aug 2011 11:24:32 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no read/write
 devices V2
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
In-Reply-To: <1312205910-13053-1-git-send-email-apw@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 09:38 AM, Andy Whitcroft wrote:
> When we mount a btrfs filesystem from read-only media there will be no
> read/write devices; for example mounting an SD card with its lock enabled.
> This triggers an immediate BUG during mount:
> 
>   kernel BUG at .../fs/btrfs/super.c:984!
> 
> This is triggered by statfs when calculating the free space in the
> filesytem.  We bug if the number of read/write devices is 0.
> 
> This check seems spurious as the information collected is valid regardless
> of whether the devices are read-only or not.  As the count is used to
> size the sort array it seems more correct to switch it to the number of
> open devices.
> 
> BugLink: http://bugs.launchpad.net/bugs/816770
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Acked-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
