Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1FZTGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 15:06:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab1FZTG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 15:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aZdCGkBDgCb88L012Q/TuKk/ZHaCXKz/lHiLej8w0HkFtCjc1TxBNxKLK0+wRTmbBv
         l+410dqSX7PxnSbpHhcKmZTTmJZ91EAMpYbBqZ/P21i/MC9bG4txtj4th27Dp8+87dpk
         3idvDdGdtyH1tS7FPhFrt+mc/Ci4S1cE50kZI=
Date: Sun, 26 Jun 2011 23:06:22 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110626190622.GB4217@albatros>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110626182628.GA20158@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 20:26 +0200, Ingo Molnar wrote:
> > > Also, i think it would be better to make this opt-out, i.e. 
> > > exclude the handful of control characters that are harmful (such 
> > > as backline and console escape), instead of trying to include the 
> > > known-useful ones.
> > 
> > Do you see any issue with the check above?
> 
> There were clear problems with the first version you posted and 
> that's enough proof to request the exclusion of known-dangerous 
> characters instead of including known-useful characters.

It doesn't proof anything.  If I/someone else did a mistake with
blacklisting would you say it is enough proof to request the inclusion
of well-known allowed characters?


> A black list is well-defined: it disables the display of certain 
> characters because they are *known to be dangerous*.

What do you do with dangerous characters that are *not yet known* to be
dangerous?


> A white list on the other hand does it the wrong way around: it tries 
> to put the 'burden of proof' on the useful, good guys - and that's 
> counter-productive really.

Really?  I think strict API definition is productive, unlike using it
in cases where it looks like working, but creating tricky and obscure
bugs.

Yes, drawing multicolor logs is funny, but ...egrrr...  printk() is not
written for these things.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
