Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1IKIbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 04:31:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42573 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1IKIbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 04:31:19 -0400
Message-ID: <4E6C705F.8010101@gmail.com>
Date: Sun, 11 Sep 2011 10:25:03 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] xip: use i_mutex for xip_file_fault
References: <4E6B82DB.50803@gmail.com> <20110910155639.GY2203@ZenIV.linux.org.uk>
In-Reply-To: <20110910155639.GY2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/09/2011 17:56, Al Viro ha scritto:
> On Sat, Sep 10, 2011 at 05:31:39PM +0200, Marco Stornelli wrote:
>> From: Marco Stornelli<marco.stornelli@gmail.com>
>>
>> There aren't sufficient sync points for a fs for xip operations. In
>> particular for the mmap case. It can be not sufficient to lock/unlock
>> to do some operation inside get_xip_mem callback. For xip_file_read
>> it's really easy to write a fs specific wrapper, xip_file_write hold
>> i_mutex so no problem. With this patch we can avoid concurrent truncate
>> operation and xip mmap.
>
> Umm...  I really don't like that; what's going to happen if you have a file
> mmapped and do write() to that file from address in that mapping?
>

Nothing strange. There is a serialization of the operations. Maybe I 
don't understand the point here.

Marco
