Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2CEQ44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:56:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51102 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751378Ab2CEQ4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:56:55 -0500
Message-ID: <1330966615.3140.6.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Joe Perches <joe@perches.com>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Mar 2012 08:56:55 -0800
In-Reply-To: <1330965033.7220.16.camel@golum>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 18:30 +0200, Artem Bityutskiy wrote:
> On Wed, 2012-02-15 at 15:56 -0800, Joe Perches wrote:
[]
> I would just kill all the levels and left only the first one - others
> are not useful. This FS is in the kernel for ages and it is safe to
> assume it is robust enough to require no level 2. And change the Kconfig
> correspondingly.
> 
> I would accept that to my l2 tree, although the final word is from
> dwmw2, of course.

Separate patch I think.

> Would it please be possible to make the patch which introduces jffs2_dbg
> macros be separate? It is very difficult to find the definition (most
> interesting in this patch) while looking at the e-mail.

Shrug.  Maybe if David W wants it so.

> How about make one more step forward and remove this prefix from all the
> messages and make it to be part of the 'jffs2_dbg' macro?

Maybe in another patch.

[]
> > +				jffs2_dbg(1, "%s(): SIGSTOP received\n",
> > +					  __func__);

				jffs2_dbg(1, "%s(): SIGSTOP received\n",
> May become a one-liner here and in many other places.

Goes beyond 80 chars.

> > +				jffs2_dbg(1, "%s(): SIGKILL received\n",
> > +					  __func__);
> 
> Ditto, and there are many other places.

Same as above.
 
> > -	D1(printk(KERN_DEBUG "jffs2_erase_block(): erase block %#08x (range %#08x-%#08x)\n",
> > -				jeb->offset, jeb->offset, jeb->offset + c->sector_size));
> > +	jffs2_dbg(1, "%s(): erase block %#08x (range %#08x-%#08x)\n",
> > +		  __func__,
> > +		  jeb->offset, jeb->offset, jeb->offset + c->sector_size);
> 
> Probably lines can be joined?

Going to have that many lines anyway.

> >  				if (jeb == c->gcblock) {
> > -					D1(printk(KERN_DEBUG "Expanding down to cover frag (0x%x-0x%x) in gcblock at %08x\n",
> > -						  frag->ofs, frag->ofs+frag->size, ref_offset(raw)));
> > +					jffs2_dbg(1, "Expanding down to cover frag (0x%x-0x%x) in gcblock at %08x\n",
> > +						  frag->ofs,
> > +						  frag->ofs + frag->size,
> > +						  ref_offset(raw));
> 
> Lines can be joined, and in other places as well.

Not really.  Try it.

> > -						  frag->ofs, frag->ofs+frag->size, jeb->offset));
> > +					jffs2_dbg(1, "Not expanding down to cover frag (0x%x-0x%x) in clean block %08x\n",
> > +						  frag->ofs,
> > +						  frag->ofs + frag->size,
> > +						  jeb->offset);
> 
> > -		D1(printk(KERN_DEBUG "Obsoleting previously unchecked node at 0x%08x of len %x: ", ref_offset(ref), freed_len));
> > +			jffs2_dbg(1, "Obsoleting previously unchecked node at 0x%08x of len %x\n",
> > +				  ref_offset(ref), freed_len);
> 
> What happened to the indentation?

Incorrect before, correct now.
It's still in a D1 block.


