Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0EZMAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:00:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34579 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0EZMAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vGE7iHcOuopdeoh80Bgpo3OMQw/GY95tWaw4fj/Y3q8/Iq3isDt58si39awXbnywgn
         oowN0+pieG5EwUOysLSOirxSOtVdsZY4a2m4BasZlFz3y1uSYIAXjgv2P7R5NkZacn8L
         91SNBP4nImq4/IkUUnFQC5Ew1YU0tU/lmoPow=
MIME-Version: 1.0
In-Reply-To: <E1OHEA9-0000Mv-8r@pomaz-ex.szeredi.hu>
References: <1274867803-3050-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHEA9-0000Mv-8r@pomaz-ex.szeredi.hu>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 26 May 2010 19:59:45 +0800
Message-ID: <AANLkTimyIyPbPd2yCuVNR6OImnFnIIxizE1ncY3ISMNH@mail.gmail.com>
Subject: Re: [PATCH 3/3] sendfile: fix sendfile
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 6:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>>
>> If output file is in non-block mode, in file should be seekable to avoid data
>> losing.
>
> Like the previous patch, I don't agree.

I don't think it isn't an API change, as the current manual page says:

" Presently  (Linux  2.6.9):  in_fd, must correspond to a file which sup-
       ports mmap(2)-like operations (i.e., it cannot be a socket); "

and if file supports mmap-like operations, it should support pread too.

>
>>
>> do_splice_from() shouldn't use sd->pos, as sd->pos is for file reading,
>> file->f_pos should be used instead.
>
> This sounds sane.
>
> These changes look like three cadidates for separate patches.  Could
> you please split this patch up, and submit the first and last change
> as a separate patch?
>

OK. I'll do that later after all the issues are concluded.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
