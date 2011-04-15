Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab1DOEBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:01:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34060 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1DOEBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b7rV1GCn+b9Vrv5t0eiWFqz/92zf4J4Z8FWw38X03efbVjbAXYsP9kLKtLIUCiBXqm
         +6XXIs7y0HusOqV7/IkXqC3N5diU4K1K/fK1Dtg1/r1i13bkDYgMRT7oExJgu503eJx9
         w54tyPmLgfuRHcVCHFNPlpCvozx6jJL2sFkxg=
Subject: Re: [PATCH] shmem: factor out remove_indirect_page()
From: Namhyung Kim <namhyung@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTin4mOMZqq4Sg04hj8Ep2XiCcZOBLg@mail.gmail.com>
References: <1302524879-4737-1-git-send-email-namhyung@gmail.com>
	 <BANLkTin4mOMZqq4Sg04hj8Ep2XiCcZOBLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 13:01:04 +0900
Message-ID: <1302840064.1537.14.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-04-14 (목), 18:27 -0700, Hugh Dickins:
> On Mon, Apr 11, 2011 at 5:27 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> > Split out some common code in shmem_truncate_range() in order to
> > improve readability (hopefully) and to reduce code duplication.
> >
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> Thank you for taking the trouble to do this.
> 
> However... all that shmem_swp index code is irredeemably unreadable
> (my fault, dating from when I converted it to use highmem with kmaps),
> and I'd rather leave it untouched until we simply delete it
> completely.
> 
> I have a patch/set (good for my testing but not yet good for final
> submission) which removes all that code, and the need to allocate
> shmem_swp index pages (even when CONFIG_SWAP is not set!): instead
> saving the swp_entries in the standard pagecache radix_tree for the
> file, so no extra allocations are needed at all.
> 
> It is possible that my patch/set will not be accepted (extending the
> radix_tree in that way may meet some resistance); but I do think
> that's the right way forward.
> 

Looks reasonable. Please feel free to ignore this then, I'll look
forward to your patches.

Thanks.


-- 
Regards,
Namhyung Kim


