Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab0FFRQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 13:16:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62709 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab0FFRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 13:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nUoKxoZt4+DLeW7W06wFmmoYX7MWda40sU4LZDXs1COs03p8YH0eUH7aJcG2YE+MP3
         kX4ewS0wtVJP26K5pcFjGUHT/noBXtOz9r+sM/pnNoNWOGXQa5oV3jdKqCTGBkbQpcoj
         uvX4Z60BGpjaOY2XnlvclbYLIMMZ4iVTYJjJ0=
Subject: Re: [PATCHv5 04/16] VFS: add memory barrier to sb_mark_clean and
 sb_mark_dirty
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
In-Reply-To: <1275835829-1478-5-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
	 <1275835829-1478-5-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 20:16:20 +0300
Message-Id: <1275844581.17909.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 17:50 +0300, Artem Bityutskiy wrote:
>  void sb_mark_dirty(struct super_block *sb);
>  static inline void sb_mark_clean(struct super_block *sb)
>  {
>  	sb->s_dirty = 0;
> +	/*
> +	 * Normally FSes first unset the sb->s_dirty flag, and then start
> +	 * synchronizing the SB. The memory barrier ensures this order.
> +	 */
> +	smp_mb();
...
>  void sb_mark_dirty(struct super_block *sb)
>  {
> +	/*
> +	 * Normally FSes modify the SB, and then mark it as dirty. The memory
> +	 * barrier ensures this order.
> +	 */
> +	smp_mb();
...

Hmm, these ones should be 'mb()', not 'smp_mb()'.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

