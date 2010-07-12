Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab0GLQmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:42:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53766 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0GLQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=UfZ2C7gJVvVNXzGr0ikWMQTnZ0J/L3PoR2APxE+VFlsM7FV7QN04G9BdiNSawfTNrY
         clCTZdkKj1PL9GoqazGa1Afu4/fLRXRo9wMGqKqK8VoGrG6KNDyyGlsygPc7B/22ELiw
         d9ulrPBtolXl7SLAMj14dJgb1WfbS7YfFATd4=
Date: Mon, 12 Jul 2010 18:40:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: crosslonelyover <crosslonelyover@gmail.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] remove unnecesary while loop in ext2_xattr_get
Message-ID: <20100712164018.GC5658@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	crosslonelyover <crosslonelyover@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
References: <201007122309063128435@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007122309063128435@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 11:09:09PM +0800, crosslonelyover wrote:
> Hi,
>      In ext2_xattr_get, we'll check the xattr entry one 
> by one in the following loop:
>          entry = FIRST_ENTRY(bh);
>          while (!IS_LAST_ENTRY(entry)) {
>                  struct ext2_xattr_entry *next =
>                          EXT2_XATTR_NEXT(entry);
>                  if ((char *)next >= end)
>                          goto bad_block;
>                  if (name_index == entry->e_name_index &&
>                      name_len == entry->e_name_len &&
>                      memcmp(name, entry->e_name, name_len) == 0)
>                          goto found;
>                  entry = next;
>          }
> We can only execute the code immediately following 
> the loop when !IS_LAST_ENTRY(entry) is true. So the
> followed while loop seems unnecessary. I think we can
> remove it.
>       Following is my patch. It's against 2.6.35-rc4.
> Please check it.
> 

Yes.  This is dead code.  This stuff is from the days before git
so we'll never know who to blame for it.

Reviewed-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

