Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2IRSW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:22:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37501 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2IRSWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <87haqvz489.fsf@tucsk.pomaz.szeredi.hu>
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu> <20120917203946.GV13973@ZenIV.linux.org.uk>
 <CA+55aFxeghUVxiFS=P+ck_BCnOuMm=HFAkqTBccxJoubk96afQ@mail.gmail.com>
 <87obl3z8jn.fsf@tucsk.pomaz.szeredi.hu> <CA+55aFxJKQMjGm00kBpj30twj1w60Mx4C0mXTJtHiJPOpu-iMA@mail.gmail.com>
 <87haqvz489.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Sep 2012 11:22:33 -0700
X-Google-Sender-Auth: Me02ZznSyAq5PRdVejrgGdCHOSc
Message-ID: <CA+55aFx62ZiBfz-eXY+n_k=BtPGudUmw-N3nm2V5i0kvmc-W7w@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: dcache: fix deadlock in tree traversal
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 9:27 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>>
>> HOWEVER. Why introduce that new DCACHE_KILLED flag at all? Wouldn't it
>> be much better to just check whether the dentry is hashed instead of
>> introducing a new flag for this case? Couldn't we just check for
>> "d_unhashed()"?
>
> Not good, because an unhashed dentry can stay around and that would mean
> that we'd need to restart the walk until the last ref to the dentry is
> dropped (which can be an arbitrary long time).

Ok, fair enough.

I'll apply your second patch as obviously fixing one issue, and wait
for Al to hopefully come up with something nicer for the first one.

         Linus
