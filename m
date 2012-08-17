Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2HQGxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:53:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64564 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2HQGxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:53:32 -0400
Message-ID: <502DE8E8.5080000@gmail.com>
Date: Fri, 17 Aug 2012 08:47:04 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, adilger.kernel@dilger.ca,
        dushistov@mail.ru
CC: bharrosh@panasas.com, bhalevy@tonian.com, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/8] ext3: remove lock/unlock super
References: <502CC4BA.3040702@gmail.com> <20120816163904.GA17526@quack.suse.cz> <20120816191909.GC31346@thunk.org>
In-Reply-To: <20120816191909.GC31346@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/08/2012 21:19, Theodore Ts'o ha scritto:
> On Thu, Aug 16, 2012 at 06:39:04PM +0200, Jan Kara wrote:
>> On Thu 16-08-12 12:00:26, Marco Stornelli wrote:
>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>
>>> Replaced lock and unlock super with a new fs mutex s_lock.
>>    Hum, is the lock needed at all? Remount & unfreeze both run with s_umount
>> held for writing. Thus we already have exclusion between these two calls.
>> The same seems to hold for ext4 BTW.
>
> Agreed, it's not clear lock_super() is needed at all for ext4 at this
> point.
>
> 	     	       		       	      - Ted
>

Great. I'll remove the calls for ext3/ext4 when I'll submit the second 
version of the patch.

Thanks for your feedback,

Marco
