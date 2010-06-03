Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0FCNm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:42:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64760 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0FCNmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c2anVMyhaMkFLXXvYOXJmNuY9XrYhK4xxkNVYoVx8C8rv5Y5SG90G7pvbwG8uIKsYJ
         xL+K9kTff2OKD2HqJTeoECmQeiQw7A8H4lkToRmn3G1ribF3VqRbcK0eZsVospKghCda
         hETzN++M4Nt/kuWd/taWIjDD5d77oxVtKwKWA=
Subject: Re: [patch v2] fcntl: return -EFAULT if copy_to_user fails
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
       Dan Carpenter <error27@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C07AD0C.8090409@oss.ntt.co.jp>
References: <20100603100402.GR5483@bicker> <4C07826A.6060302@oss.ntt.co.jp>
	 <20100603103542.GV5483@bicker> <4C07990A.8080508@fusionio.com>
	 <4C079D34.5010500@oss.ntt.co.jp> <1275568683.2456.33.camel@edumazet-laptop>
	 <20100603131031.GM6822@laptop>  <4C07AD0C.8090409@oss.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 15:42:43 +0200
Message-ID: <1275572563.2456.37.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 juin 2010 à 22:24 +0900, Takuya Yoshikawa a écrit :
> (2010/06/03 22:10), Nick Piggin wrote:
> > On Thu, Jun 03, 2010 at 02:38:03PM +0200, Eric Dumazet wrote:

> >> This is really ugly.
> >>
> >> static inline int sec_copy_to_user(arg1, arg2, arg3)
> >> {
> >> 	int res = copy_to_user(arg1, arg2, arg3);
> >>
> >> 	return (res>  0) ? -EFAULT : res;
> >> }
> >
> > It would be unfortunate if it adds more confusion. I'd prefer to have
> > a sufficiently different name. memcpy_to_user/memcpy_from_user
> > perhaps?
> 
> Then, and memclear_user() ?
> 
> >
> 

We are interested by the fact that full copy is done, so maybe use the
'full' prefix ?

fullcopy_to_user() , fullclear_user() ?



