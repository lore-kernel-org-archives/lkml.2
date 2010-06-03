Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0FCMiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:38:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42347 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0FCMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZxVic8q/HyHJiGsCIoZslpQUZaiOnLKRnl18GXNDgny9MaY44myKmd4OK+oYi1HoJg
         c8VybTQzOX1H0JA6czu8o8w9DVX0zw94/Ii/CzYIomsy1vSzzofd89CmZEQLoBx6jjuP
         kRYkdwJ1EuQ0swE6TCZpnGIZ76QQuxMRMwnVA=
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Jens Axboe <jaxboe@fusionio.com>, Dan Carpenter <error27@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C079D34.5010500@oss.ntt.co.jp>
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp>
	 <20100603103542.GV5483@bicker> <4C07990A.8080508@fusionio.com>
	 <4C079D34.5010500@oss.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 14:38:03 +0200
Message-ID: <1275568683.2456.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 juin 2010 à 21:16 +0900, Takuya Yoshikawa a écrit :
> (2010/06/03 20:59), Jens Axboe wrote:
> > On 2010-06-03 12:35, Dan Carpenter wrote:
> >> copy_to_user() returns the number of bytes remaining, but we want to
> >> return -EFAULT.
> >> 	ret = fcntl(fd, F_SETOWN_EX, NULL);
> >> With the original code ret would be 8 here.
> >>
> >> V2: Takuya Yoshikawa pointed out a similar issue in f_getown_ex()
> >
> > Pretty basic bug, how long has this been there?
> 
> IIUC, from the beginning, when these were introduced.

Maybe copy_to_user() was changed sometime to return a partial count
instead of EFAULT ?

I do think we should have a set of helper functions, instead of
spreading special EFAULT cases in one housand places...

This is really ugly.

static inline int sec_copy_to_user(arg1, arg2, arg3)
{
	int res = copy_to_user(arg1, arg2, arg3);

	return (res > 0) ? -EFAULT : res;
}



