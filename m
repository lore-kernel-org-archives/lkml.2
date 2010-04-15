Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0DOF61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:58:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55075 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0DOF60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XtpinHUijt34NPQL776luy/m0ZHmO8WwnHLSm9/+h5L0PZgQLJy1WmxyA3pu7g2ETo
         k68NYFmyQiQBe/3ChXNXILDw6VloYg5qtjlzZQBWTWWpE/8ZO9XESRiupEYQTpjgzcBV
         DbazihI4zlVIxIQhUCe4pZcD5AIe43lFVwZ7c=
MIME-Version: 1.0
In-Reply-To: <20100413135416.b537eee8.akpm@linux-foundation.org>
References: <20100331124834.192500@gmx.com> <20100413135416.b537eee8.akpm@linux-foundation.org>
From: Steven B <damentz@gmail.com>
Date: Thu, 15 Apr 2010 00:58:05 -0500
Message-ID: <o2k8c2bb01004142258zd1a02d38ib2128e324b7d9947@mail.gmail.com>
Subject: Re: high iowait problem(Bug 12309 on bugzilla.kernel.org)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frank Ren <frankrq2009@gmx.com>, mingo <mingo@elte.hu>,
       "a.p.zijlstra" <a.p.zijlstra@chello.nl>,
       "jens.axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> So something between 2.6.32.3 and 2.6.32.8 inclusive rebroke the
> kernel.  That's useful info.
>
> Looking at the changelogs, the only thing I can immediately see in the
> block-core area is
>
> : commit cb723ba5d03bf719dbc7409b4d67572d4472ef8b
> : Author: Dmitry Monakhov <dmonakhov@openvz.org>
> : Date:   Wed Jan 27 22:44:36 2010 +0300
> :
> :     block: fix bio_add_page for non trivial merge_bvec_fn case
>
> which seems unlikely.
>
> I'm seeing just one device-mapper change whcih went in over that
> timeframe:
>
> : commit e0f5cfa7c18b411634e73923841eccd3a4c0ce7f
> : Author: Martin K. Petersen <martin.petersen@oracle.com>
> : Date:   Mon Jan 11 03:21:50 2010 -0500
> :
> :     DM: Fix device mapper topology stacking
>
>

Although I can't provide any big details, I went through the commits between
2.6.32.2 and 2.6.32.8 and as many things that could affect IO and reverted
them from my 2.6.33.2 kernel.

Here's my list of commits I reverted that seemed to improve performance locally
running a 2.6.33.2 kernel.

cb723ba5d03bf719dbc7409b4d67572d4472ef8b (this one you suspected)
block: fix bio_add_page for non trivial merge_bvec_fn case

b2ea8cb9c8f1937cb80b9beb50548a05bfc37819
vmscan: do not evict inactive pages when skipping an active list scan

e4dd8ca5be771aa706b0797b3284328bb595bfa1
fasync: split 'fasync_helper()' into separate add/remove functions

Though, I was hoping you guys could identify which one of these is
the real culprit.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
