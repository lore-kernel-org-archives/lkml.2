Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0FCMp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:45:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:32858 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0FCMp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LZ2tXUB6YdKiTB0ps0h93Lz36zEHjWUPxirhlvWas9AdbbDtD/btvskQ7RfreIzTnc
         PkAbTo4pOUmo8ioMTm8Et8R/P88LxIMDoeCkkoL49uWg+b82yfUA58sHlttipQsJBD6Q
         5SvrvxiBAmrDaLJSglkqNpV3fIDW+Arm9sDfc=
Date: Thu, 3 Jun 2010 14:45:36 +0200
From: Dan Carpenter <error27@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Jens Axboe <jaxboe@fusionio.com>, Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
Message-ID: <20100603124536.GW5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
	Jens Axboe <jaxboe@fusionio.com>, Matthew Wilcox <matthew@wil.cx>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp> <20100603103542.GV5483@bicker> <4C07990A.8080508@fusionio.com> <4C079D34.5010500@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C079D34.5010500@oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:16:52PM +0900, Takuya Yoshikawa wrote:
> (2010/06/03 20:59), Jens Axboe wrote:
>> On 2010-06-03 12:35, Dan Carpenter wrote:
>>> copy_to_user() returns the number of bytes remaining, but we want to
>>> return -EFAULT.
>>> 	ret = fcntl(fd, F_SETOWN_EX, NULL);
>>> With the original code ret would be 8 here.
>>>
>>> V2: Takuya Yoshikawa pointed out a similar issue in f_getown_ex()
>>
>> Pretty basic bug, how long has this been there?
>
> IIUC, from the beginning, when these were introduced.
>
> And I recently sent similar bug fixes for other parts.
>

It was your clear_user() patch which inspired me.  I wrote a smatch
check to find these.  I've pushed the code to the smatch repo.
http://repo.or.cz/r/smatch.git

The heuristic I use is that if we return a variable which is the 
return value of copy_to_user() and it's non-zero then complain.  It 
didn't find the f_getown_ex() because that return value could come from
copy_to_user() or it could be -EINVAL.

I'll mess with it a bit and see if I can make it catch the f_getown_ex()
bug.

regards,
dan carpenter


