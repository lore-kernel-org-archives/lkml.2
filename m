Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0GJJXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:23:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46490 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0GJJXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=W0ze//wV4gFge1tee+O+1wl8x8TCUPaW/hg4ldPSnN5WaZ4mGSuHtf6hJT5x7oiPd7
         PBkWmt4xP3rIF5wtKD9dzk+2lc06DKYIVYgyB42uZENp3s60/E+Kojrwll3A7zOby70U
         AVzZChwxK0lq6oUGGixtccfbv5z0+/3GcEn6s=
Date: Sat, 10 Jul 2010 11:21:52 +0200
From: Dan Carpenter <error27@gmail.com>
To: shenghui <crosslonelyover@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] avoid NULL deference in ext2_xattr_get
Message-ID: <20100710092151.GS19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	shenghui <crosslonelyover@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimwrORk9yfJlSMpVdn1V0sg0tssKhxc-3q1xoMX@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another way to fix this would be to say:

   	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
-  		  name_index, name, buffer, (long)buffer_size);
+  		  name_index, name ?: "(null)", buffer, (long)buffer_size);

That would help for debugging.

regards,
dan carpenter


