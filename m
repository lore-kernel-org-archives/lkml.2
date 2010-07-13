Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0GMXri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 19:47:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59738 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0GMXrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 19:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LL0egVzFI4FrBlVqafBtewBMJ5gLzFfmgaRs7y20fjQq0ePBz+pTPwr4OjpNSaoqVW
         pelw33VHGKQjdPgum6sRCtXSE0AfREpZ5DOZ5xDD6YxZcdg3+vAw2P97Rvy4ENLWoldo
         HbMl4XVtEjlF6d6CjkDgNtkz0lkQLi29uRfLQ=
MIME-Version: 1.0
In-Reply-To: <7D4617C2-565E-4F34-94B4-3F308EB75D18@dilger.ca>
References: <4C3C7E59.8040905@gmail.com>
	<7D4617C2-565E-4F34-94B4-3F308EB75D18@dilger.ca>
Date: Wed, 14 Jul 2010 07:47:36 +0800
Message-ID: <AANLkTinbNujdr6qM7kMyOLFMqjRibwvLZIfMB6J3MzX3@mail.gmail.com>
Subject: Re: [PATCH] ext2: return -ENODATA for NULL i_file_acl in 
	ext2_xattr_list
From: shenghui <crosslonelyover@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: kernel-janitors <kernel-janitors@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Andreas Dilger <adilger@dilger.ca>:
> The "error" value gets overwritten almost immediately with -EIO, and then at the end of the function if there is an xattr block but it doesn't contain any attributes (I'm not sure if this could happen, but it seems possible) it will return "error = buffer_size - rest;  /* total size */", so 0 if "rest" was not changed from its initial value of buffer_size.
>
> The question is why this return value should be changed to -ENODATA in the first place?  This isn't true for ext3_xattr_list() or ext4_xattr_list().  I tend to think it is not an error to get back an empty list, and applications shouldn't treat it as such.  Most applications will check "if (rc < 0)" and treat it as an error.  This is different than e.g. requesting a specific value by name (which does return -ENODATA) because it would otherwise be ambiguous whether the xattr existed but had zero size or didn't exist at all.
>

Thanks for your explanation!

-- 


Thanks and Best Regards,
shenghui
