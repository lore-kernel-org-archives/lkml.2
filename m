Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1IRIst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:48:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39805 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1IRIsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:48:47 -0400
Message-ID: <4E75AEFD.105@gmail.com>
Date: Sun, 18 Sep 2011 10:42:37 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: jeff.liu@oracle.com
CC: Andi Kleen <ak@linux.intel.com>, Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com> <4E759DE5.3020907@oracle.com>
In-Reply-To: <4E759DE5.3020907@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/09/2011 09:29, Jeff Liu ha scritto:
> Hi Andreas and Andi,
>
> Thanks for your comments.
>
> On 09/18/2011 09:46 AM, Andi Kleen wrote:
>
>>>> with an additional improvement if the offset is larger or equal to the
>>>> file size, return -ENXIO in directly:
>>>>
>>>>                 if (offset>= inode->i_size) {
>>>>                         mutex_unlock(&inode->i_mutex);
>>>>                         return -ENXIO;
>>>>                 }
>>>
>>> Except that is wrong, because it would then be impossible to write sparse files.
>
> Per my tryout, except that, if the offset>= source file size, call
> lseek(fd, offset, SEEK_DATA/SEEK_HOLE) against Btrfs will always return
> the total file size rather than -ENXIO.  however, our desired result it
> -ENXIO in this case, Am I right?
>

Yes, ENXIO should be the operation result.
