Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab0EKGmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:42:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39835 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab0EKGmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Vr7tcypE4Cp6Oc3Svo5U+wVNGpRWb+rlVtRtslCI/5z+KHqG+jujq+8ObfLCfbIKCA
         Chzw33yIgT4Cmmi1ML8YgYIlOO2TfC7/676lgfMdHa8+BNc6jZa/emdTOaoM2AksazYH
         aSb/e5oT2AASiu6y1FNFuTiyU4UAiJRGfvDck=
MIME-Version: 1.0
In-Reply-To: <20100511063309.GC9644@core.coreip.homeip.net>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
	 <1273488154-2993-1-git-send-email-os@emlix.com>
	 <20100510142225.4bf215ef.akpm@linux-foundation.org>
	 <20100511060547.GA9644@core.coreip.homeip.net>
	 <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>
	 <20100511062110.GB9644@core.coreip.homeip.net>
	 <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com>
	 <20100511063309.GC9644@core.coreip.homeip.net>
Date: Tue, 11 May 2010 09:42:03 +0300
X-Google-Sender-Auth: 68438574826831d5
Message-ID: <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, May 11, 2010 at 9:33 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>> what guarantee exactly do you have for that statement ?
>
> The data is kmalloced, kmalloc aligns on cacheline boundary AFAIK which
> means that next kmalloc data chunk will not share "our" cacheline.

No, there are no such guarantees. kmalloc() aligns on
ARCH_KMALLOC_MINALIGN or ARCH_SLAB_MINALIGN depending on which is
bigger but beyond that, there are no guarantees. You can, of course,
use kmem_cache_create() with SLAB_HWCACHE_ALIGN to align on cacheline
boundary.

                        Pekka
