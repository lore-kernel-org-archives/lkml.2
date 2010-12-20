Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0LTBsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:48:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:58518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0LTBsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=db8aycVGzt3fibw5i0Vfu64oPpH7i4A8Yw5yq1Aai6Of2KF/8rDrbcffP3awOv8d/o
         9XO+pu5HXSxmCGnYCuLw==
MIME-Version: 1.0
In-Reply-To: <131961.1292667059@localhost>
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
	<131961.1292667059@localhost>
Date: Sun, 19 Dec 2010 17:48:05 -0800
Message-ID: <AANLkTik4ffEzb_zzEN7Y+fksSkr+6HZs5Szd4VupH4+-@mail.gmail.com>
Subject: Re: mmotm 2010-12-16 - breaks mlockall() call
From: Michel Lespinasse <walken@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 2:10 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 16 Dec 2010 14:56:39 PST, akpm@linux-foundation.org said:
>> The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to
>>
>>    http://userweb.kernel.org/~akpm/mmotm/
>
> The patch mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
> causes this chunk of code from cryptsetup-luks to fail during the initramfs:
>
>        if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
>                        log_err(ctx, _("WARNING!!! Possibly insecure memory. Are you root?\n"));
>                        _memlock_count--;
>                        return 0;
>                }
>
> Bisection fingered this patch, which was added after -rc4-mmotm1202, which
> boots without tripping this log_err() call.  I haven't tried building a
> -rc6-mmotm1216 with this patch reverted, because reverting it causes apply
> errors for subsequent patches.
>
> Ideas?

I had a quick look, but didn't figure out much so far.

Could you send me your initramfs image and .config file so I can
reproduce the issue locally ?

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
