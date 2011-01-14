Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1ANJRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:17:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57631 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab1ANJR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=o2Ggp+K9e6J4nUULM/yRAw2TpuGxv1CpHh2omgh/NkkiAjQRGPw9yPo4hmxiR0cdlw
         tZtmIq2X1y/R5w/B4TV6FIvu7n88iSSzy+fAzaER9aj7hhOyUNMVZMBDNWRAZaGt71Ts
         hSb2Fqa8biNy/xBRQegB7JvjTCLrcWF2os/OA=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTi=pzFGHyFDYM_qvabODdKn8gDvRjjo_nbPfcT=q@mail.gmail.com>
References: <7352.1294971049@jrobl>
	<AANLkTinXPOSxHPtffqe3m5MWppDfr6kFVMsd6k7-dkic@mail.gmail.com>
	<20110114052813.GZ19804@ZenIV.linux.org.uk>
	<AANLkTi=pzFGHyFDYM_qvabODdKn8gDvRjjo_nbPfcT=q@mail.gmail.com>
Date: Fri, 14 Jan 2011 10:17:25 +0100
Message-ID: <AANLkTik=7x9o3s_TeVAACjNachLE7zyrbqyOeBBiE-v5@mail.gmail.com>
Subject: Re: vfs-scale, nd->inode after __do_follow_link()
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Piggin <npiggin@gmail.com>, patchwork@lists.ozlabs.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, webmaster@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 9:40 AM, Nick Piggin <npiggin@gmail.com> wrote:
> On Fri, Jan 14, 2011 at 4:28 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Fri, Jan 14, 2011 at 03:09:10PM +1100, Nick Piggin wrote:
>>
>>> > + ? ? ? ? ? ? ? ? ? ? ? struct dentry *i = path.dentry->d_inode;
>>> > + ? ? ? ? ? ? ? ? ? ? ? if (!IS_ERR(cookie) && i->i_op->put_link)
>>> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? i->i_op->put_link(path.dentry, &nd, cookie);
>>> > ? ? ? ? ? ? ? ? ? ? ? ?/* nd.path had been dropped */
>>> > ? ? ? ? ? ? ? ? ? ? ? ?nd.path = path;
>>> > ? ? ? ? ? ? ? ? ? ? ? ?goto out_path;
>>>
>>> It should be the inode we followed, rather than the inode of the
>>> new path, I think.
>>
>> And that's what the first argument of __do_follow_link() is.  I'm actually
>> tempted to rename it from path to symlink and make it const to clarify
>> the things a bit.
>
> Yes I was completely wrong there, thanks again for another good
> catch. I'll merge this in the vfs-scale branch, and ask to merge if
> there are no objections.
>

[ CCing patchwork ML ]

Can you send your patch separately, please?
Within a (long) thread it is eaten up.

As *.patch are somehow not presented as diff (see [1]), someone can't
catch them from <patchwork.k.o>.

Furthermore, it would be very cool to see linux-fsdevel (patches from
its ML) in <patchwork.d.o>.
I don't know whom to contact from the linux-fsdevel ML, sorry for this.

- Sedat -

[1] http://lkml.org/lkml/2011/1/14/55
