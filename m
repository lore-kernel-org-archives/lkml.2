Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0FFTW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 15:22:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61804 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0FFTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 15:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cn1foPGo/2OP2Tx6QguDXmSUJYrR7nqRyYqZa8fb1WZXkQ8T9i3FUVICZQm2vUW3q3
         jtEKi9GoGMkdWDar0NSs5altYZplGBFP0eTik51ujU16Yjcz4Y7pGMA8SiBQ/ebHEZZi
         /NV/tzoAhn4YpKDHcU6VthBOGCsg8WHsi8U/Y=
Subject: Re: [PATCHv5 04/16] VFS: add memory barrier to sb_mark_clean and
 sb_mark_dirty
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
In-Reply-To: <1275844581.17909.2.camel@localhost.localdomain>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
	 <1275835829-1478-5-git-send-email-dedekind1@gmail.com>
	 <1275844581.17909.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 22:22:22 +0300
Message-Id: <1275852142.17909.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 20:16 +0300, Artem Bityutskiy wrote:
> On Sun, 2010-06-06 at 17:50 +0300, Artem Bityutskiy wrote:
> >  void sb_mark_dirty(struct super_block *sb);
> >  static inline void sb_mark_clean(struct super_block *sb)
> >  {
> >  	sb->s_dirty = 0;
> > +	/*
> > +	 * Normally FSes first unset the sb->s_dirty flag, and then start
> > +	 * synchronizing the SB. The memory barrier ensures this order.
> > +	 */
> > +	smp_mb();
> ...
> >  void sb_mark_dirty(struct super_block *sb)
> >  {
> > +	/*
> > +	 * Normally FSes modify the SB, and then mark it as dirty. The memory
> > +	 * barrier ensures this order.
> > +	 */
> > +	smp_mb();
> ...
> 
> Hmm, these ones should be 'mb()', not 'smp_mb()'.

Actually no, sorry, I completely missed that all memory barriers are a
compiler barriers. I thought smp_mb() is nought, which is not true -
smp_mb() is a barrier() on UP.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

