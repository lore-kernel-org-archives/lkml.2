Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0FNVVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:21:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62584 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab0FNVVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r3YZ39s6PfPMqOc8lwj1doAe8wutSgXIG8LrbUErSz7qwX1whIukXhWa2MKYtq6y1z
         xwqD+M5sKR8pCR+39SMBKmr2i+3cvAtgDqJt61gOGWmE1GILLzC0hyApdU6rlq4XpVGt
         U5HaG+oGkYyCX58vBHdx9NASiDKnkdBHg2LDY=
Message-ID: <4C169D71.90800@gmail.com>
Date: Mon, 14 Jun 2010 14:21:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Edward Shishkin <edward.shishkin@gmail.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8]reiserfs:stree.c Fix variable set but not used.
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-2-git-send-email-justinmattock@gmail.com> <4C1699AA.3000900@gmail.com>
In-Reply-To: <4C1699AA.3000900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 02:05 PM, Edward Shishkin wrote:
> Justin P. Mattock wrote:
>> Not sure if this is correct or not.
>> the below patch gets rid of this warning message
>> produced by gcc 4.6.0
>>
>> fs/reiserfs/stree.c: In function 'search_by_key':
>> fs/reiserfs/stree.c:602:6: warning: variable
>> 'right_neighbor_of_leaf_node' set but not used
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
>

o.k.!!
what about the whitespace issue?
from what I remember I did notice the "+"
that git does when making patches like this
but given some many of these warnings I just
did a quick workaround or however then figured
to worry later on that.

>> ---
>> fs/reiserfs/stree.c | 7 ++-----
>> 1 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
>> index 313d39d..73086ad 100644
>> --- a/fs/reiserfs/stree.c
>> +++ b/fs/reiserfs/stree.c
>> @@ -599,7 +599,6 @@ int search_by_key(struct super_block *sb, const
>> struct cpu_key *key, /* Key to s
>> struct buffer_head *bh;
>> struct path_element *last_element;
>> int node_level, retval;
>> - int right_neighbor_of_leaf_node;
>> int fs_gen;
>> struct buffer_head *reada_bh[SEARCH_BY_KEY_READA];
>> b_blocknr_t reada_blocks[SEARCH_BY_KEY_READA];
>> @@ -617,8 +616,7 @@ int search_by_key(struct super_block *sb, const
>> struct cpu_key *key, /* Key to s
>>
>> pathrelse(search_path);
>>
>> - right_neighbor_of_leaf_node = 0;
>> -
>> +
>> /* With each iteration of this loop we search through the items in the
>> current node, and calculate the next current node(next path element)
>> for the next iteration of this loop.. */
>> @@ -695,8 +693,7 @@ int search_by_key(struct super_block *sb, const
>> struct cpu_key *key, /* Key to s
>> starting from the root. */
>> block_number = SB_ROOT_BLOCK(sb);
>> expected_level = -1;
>> - right_neighbor_of_leaf_node = 0;
>> -
>> +
>> /* repeat search from the root */
>> continue;
>> }
>
>

