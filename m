Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab1JNPFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:05:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48753 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab1JNPFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:05:43 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        akpm@linux-foundation.org, toshi.okajima@jp.fujitsu.com
Subject: Re: [PATCH 10/13] filesystems: add set_nlink()
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
	<1318430946-7091-11-git-send-email-miklos@szeredi.hu>
	<1318523599.2719.45.camel@menhir>
Date: Fri, 14 Oct 2011 17:04:49 +0200
In-Reply-To: <1318523599.2719.45.camel@menhir> (Steven Whitehouse's message of
	"Thu, 13 Oct 2011 17:33:19 +0100")
Message-ID: <87fwivaa26.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Whitehouse <swhiteho@redhat.com> writes:

> Hi,
>
> On Wed, 2011-10-12 at 16:49 +0200, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>> 
>> Replace remaining direct i_nlink updates with a new set_nlink()
>> updater function.
>> 
>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> ---
> [snip]
>
>
>
>> diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
>> index da21eca..102cf5e 100644
>> --- a/fs/gfs2/glops.c
>> +++ b/fs/gfs2/glops.c
>> @@ -277,7 +277,7 @@ static void gfs2_set_nlink(struct inode *inode, u32 nlink)
>>  		if (nlink == 0)
>>  			clear_nlink(inode);
>>  		else
>> -			inode->i_nlink = nlink;
>> +			set_nlink(inode, nlink);
>>  	}
>>  }
>
> So long as it is ok to call set_nlink() with nlink == 0, then the if
> statement here can be removed and just replaced with set_nlink()

Current patchset will WARN if set_nlink() is called with nlink == 0.  I
think it's cleaner to keep the two cases separate.

Thanks,
Miklos
