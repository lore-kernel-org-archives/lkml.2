Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0DLWcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:32:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47782 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0DLWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PmmMA3tlxgQGRVH8wcphvI2aXAIv3QEz1p6jKmMLYru7emOEzs4HARA8HEcq2+ymDR
         WMtPih5jvEv+iYk2ujy9Znthyssi/W/i666k5Hf/jMgaPyDWHKWu6Ch2Q+7q/7lmeF0w
         Z+RNw/QtzRmzWTVLClR5GLIJuFO3ox0r4OqoI=
MIME-Version: 1.0
In-Reply-To: <20100412213327.GA4463@joi.lan>
References: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
	 <1271030068.3554.1.camel@localhost> <20100412113438.GB2789@joi.lan>
	 <1271104101.5726.3.camel@t60prh> <20100412213327.GA4463@joi.lan>
Date: Tue, 13 Apr 2010 08:32:29 +1000
Message-ID: <n2t21d7e9971004121532y394d2f29rf018d8f33769ba57@mail.gmail.com>
Subject: Re: [PATCH 1/3] fbmem: fix aperture overlapping check
From: Dave Airlie <airlied@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
       nouveau@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Ok, thanks for explanation. I'll drop this patch and rebase the others.

Cool,

>> You won't be able to make this work for vga16fb from what I can see
>> since it access 0xa000 directly, not via any of the defined apertures
>> that vesafb/offb use. vga16fb will need a different approach I suspect.
>
> Yeah, there's an idea to claim 0xa0000 as an aperture of vga16fb and then
> do the same in KMS driver but only if it's the primary card.
> (You hinted to use SHADOW resource bit to check whether card is primary)
> I think I'll try this approach soon.

Yeah as long as we kick it off once, certain things like vga switcheroo change
who the primary gpu is at runtime.

but it should be okay if both drivers have the kickoff paths.

Dave.
