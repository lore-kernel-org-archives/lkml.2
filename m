Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2JNKfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:35:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60577 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2JNKfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:35:02 -0400
Message-ID: <507A93C4.8020509@gmail.com>
Date: Sun, 14 Oct 2012 12:28:20 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 06/22] ocfs2: drop vmtruncate
References: <506FE92F.2000609@gmail.com> <20121013161951.GC19899@infradead.org>
In-Reply-To: <20121013161951.GC19899@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/10/2012 18:19, Christoph Hellwig ha scritto:
>>   	if ((attr->ia_valid & ATTR_SIZE) &&
>>   	    attr->ia_size != i_size_read(inode)) {
>> -		status = vmtruncate(inode, attr->ia_size);
>> +		status = inode_newsize_ok(inode, attr->ia_size);
>>   		if (status) {
>>   			mlog_errno(status);
>>   			goto bail_commit;
>>   		}
>> +		truncate_setsize(inode, attr->ia_size);
>
> ocfs2 already calls inode_newsize_ok earlier during ocfs2_setattr,
> and there's an XXX comment just above the vmtruncate call about
> how ocfs2 hacks around this.  I suspect you just want a plain
> truncate_setsize here and remove the comment above it, but I'd
> like to have the ocfs2 folks confirm that.
>
>

Yep, I quite agree. truncate_setsize can be moved up into to the 
previous "if (size_change && attr->ia_size != i_size_read(inode))" where 
the truncate code does its work.
