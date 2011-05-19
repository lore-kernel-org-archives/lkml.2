Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458Ab1ESP7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:59:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59430 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab1ESP7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZGAL3gIhJoH/9Aa5kXMOoLaHETQjNQrGTXnMCtW5i6dpUPSj85quj+njJg8JZzWKEh
         54NwH8DKaz6GVoVTnbMHEtQJiwxw1KYL/mXe3gkZe8BiKn1h1+qUyXgnS8UWbgzKvK0O
         zepTEiqXoAlH1+mZzBuFoSGpwnXNcUbWi519Y=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=nmvdKNaNDCUUZQF3QX-jDydTSng@mail.gmail.com>
References: <1305196419.2713.84.camel@localhost>
	<1305751647-3122-1-git-send-email-bengardiner@nanometrics.ca>
	<BANLkTi=+V7PR_29pK3ooVggPmeicCG0eWg@mail.gmail.com>
	<BANLkTi=nmvdKNaNDCUUZQF3QX-jDydTSng@mail.gmail.com>
Date: Thu, 19 May 2011 11:59:52 -0400
Message-ID: <BANLkTimiELh42LKgjicvh7jvXVfHeFE6MA@mail.gmail.com>
Subject: Re: [PATCH] UBIFS: don't fail on -EBADMSG when fixing free space
From: "Matthew L. Creech" <mlcreech@gmail.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 9:28 AM, Ben Gardiner
<bengardiner@nanometrics.ca> wrote:
>
> So I guess my particular situation is a problem with the davinci nand
> driver's ECC for 0xFF data and is _not_ covered by the free space
> fixup?
>

Yeah, that's what it sounds like.

Can you reproduce the -EBADMSG with a simpler test case that leaves
UBI/UBIFS out of the equation?  Maybe enable write-verify in U-Boot
and try using "nand write" again, or use mtd-utils "nandwrite" from an
initramfs image then try to read back the data -- that should give a
simpler test case that shows whether the ECC handling of empty space
is wrong.

If so, that probably needs to be fixed at the MTD level, since it will
affect more than this particular UBIFS case.

-- 
Matthew L. Creech
