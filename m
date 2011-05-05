Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1EETfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1EETfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:35:03 -0400
Message-ID: <4DC2FBE4.9060608@redhat.com>
Date: Thu, 05 May 2011 15:35:00 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <4DC2F84F.8030107@gmail.com>
In-Reply-To: <4DC2F84F.8030107@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 03:19 PM, Marco Stornelli wrote:
> Il 04/05/2011 19:58, Josef Bacik ha scritto:
>> + if (offset>= i_size_read(inode)) {
>> + mutex_unlock(&inode->i_mutex);
>> + return -ENXIO;
>> + }
>> + offset = i_size_read(inode);
>> + break;
>
> I can add that generic_file_llseek_unlocked means *unlocked* so you
> shouldn't unlock any mutex but only return a value. The current version,
> in case of SEEK_END uses directly i_size indeed, so maybe I'm missing
> something.

Yeah this was a copy+paste mistake, ext4 has it's own llseek that I 
modified to run my tests against and then I just copied and pasted it 
over to the generic things.  I've fixed this earlier, I'll be sending a 
refreshed set out soon.  Thanks,

Josef
