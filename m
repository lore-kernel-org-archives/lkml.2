Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab1ANEBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:01:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57005 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1ANEBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:01:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NrUcsQFv4w2y/ZN+CM9DbT462MNG8QidWTYvg4ICNTumhEt1jLWM7ZP4YB0X/VwMTu
         UBOjc/Xl9tI75QmCIS/TP2KTUVe1osfXcwd8EOQgFX4jazcE/c4creRHA51we2WTMc1T
         1eCsKJjgmOWspEXOgQYP2rpBzqteehQy8tbEo=
MIME-Version: 1.0
In-Reply-To: <8406.1294976295@jrobl>
References: <8406.1294976295@jrobl>
Date: Fri, 14 Jan 2011 15:01:37 +1100
Message-ID: <AANLkTi=jozto+CNwfSKu2_dGWXaRi5p=3dqQngMz7g24@mail.gmail.com>
Subject: Re: vfs-scale, keep the errno
From: Nick Piggin <npiggin@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 2:38 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> When open(2) without O_DIRECTORY opens an existing dir, it should return
> EISDIR. In do_last(), the variable 'error' is initialized EISDIR, but it
> is changed by d_revalidate() which returns any positive to represent
> 'the target dir is valid.'
> Should we keep and return the initialized 'error' in this case.

Great, thank you very much. I just changed a few variable names but
applied it. Would you please add you Signed-off-by: on patches from
now on?

Good reviewing work. Are you finding these by review or testing? I
think ltptests on an nfs mount should find this kind of bug... which I
should do.

Thanks,
Nick
