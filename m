Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab2CGQHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:07:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44226 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CGQHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:07:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120307155624.GC19570@parisc-linux.org>
References: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120307155624.GC19570@parisc-linux.org>
Date: Wed, 7 Mar 2012 21:37:01 +0530
Message-ID: <CAOD=uF6nG=r9GLtzdds8T_67RmOyOhD756Kj_EGXsuDgfQR7nA@mail.gmail.com>
Subject: Re: [PATCH] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in sd_dif_prepare().
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        mkp@mkp.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 9:26 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Mar 07, 2012 at 08:11:35PM +0530, santosh nayak wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> Value of BIO_MAPPED_INTEGRITY is 11. Intention was to set the 11th bit.
>
> Also, can we introduce:
>
> #define bio_set_flag(bio, flag) ((bio)->bi_flags |= (1 << (flag)))
>

  set_bit() can do the same task.
  Can you please explain why do we need a new macro ?


> Then hunt down and kill all the places that manipulate bi_flags by hand?
> We might also need:
>
> #define bio_set_flag_atomic(bio, flag) set_bit(&(bio)->bi_flags, (flag))

for atomic operation we have __set_bit() . Is there any need to define
to new macro ?


Regards
Santosh

>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
