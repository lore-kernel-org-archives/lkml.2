Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1ERVlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:41:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34580 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1ERVlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QghRWw3WlOPrjXjU83qRsGEFTUXwdN5gW/hyY68kc3DkYH8ZULbQuaBWBlByKc46Aq
         quoii9yLgON9tfx7KtlV/QC2hUarafbFdx9FCe7xK9mEoxVUfHuU+0+ED0v2ovAQivRU
         ZwWaYkrGuy3GgDFhtgWawAGprDWTyOL/h8OZs=
MIME-Version: 1.0
In-Reply-To: <1305751647-3122-1-git-send-email-bengardiner@nanometrics.ca>
References: <1305196419.2713.84.camel@localhost>
	<1305751647-3122-1-git-send-email-bengardiner@nanometrics.ca>
Date: Wed, 18 May 2011 17:41:11 -0400
Message-ID: <BANLkTi=+V7PR_29pK3ooVggPmeicCG0eWg@mail.gmail.com>
Subject: Re: [PATCH] UBIFS: don't fail on -EBADMSG when fixing free space
From: "Matthew L. Creech" <mlcreech@gmail.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 4:47 PM, Ben Gardiner
<bengardiner@nanometrics.ca> wrote:
> +       /*
> +        * Don't fail on -EBADMSG since these are precisely the error codes that
> +        * are returned by ubi_red in the cases where free-space fix-ups are
> +        * required.
> +        */

Hi Ben,

Off-hand, I don't see how this comment can be true.  It seems like
we'll have 2 cases:

1. The pages in question are actually erased, in which case they'll be
0xff-filled by ubi_read() without error, or
2. The pages were programmed with all 0xff data, in which case the ECC
info should be correct

There's a third possibility, that the ECC info is bad because there's
a real error, but that's not something we can reliably recover from.
Am I overlooking another scenario?

-- 
Matthew L. Creech
