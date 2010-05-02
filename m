Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab0EBRip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 13:38:45 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36208 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab0EBRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 13:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=asieCBpnTzQtJQcfnwClkcVyb9OqqNDaDfw6TEiuxuBjkf4CrSvFMshmJNYUx1vl6n
         cDUpLnU4yVKl0qVs5fMUC0IN1dtzj6DJV3hXWOGiiIo8Q7kC4y690o8WrlHBupaH7eiK
         Z1W2wBX/geXCje/bFGMlKBrOAON2Bp4tX9mZY=
MIME-Version: 1.0
In-Reply-To: <1272812038-32484-2-git-send-email-avi@redhat.com>
References: <1272812038-32484-1-git-send-email-avi@redhat.com>
	 <1272812038-32484-2-git-send-email-avi@redhat.com>
Date: Sun, 2 May 2010 13:38:41 -0400
Message-ID: <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
From: Brian Gerst <brgerst@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dexuan Cui <dexuan.cui@intel.com>, Sheng Yang <sheng@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 2, 2010 at 10:53 AM, Avi Kivity <avi@redhat.com> wrote:
> The fpu code currently uses current->thread_info->status & TS_XSAVE as
> a way to distinguish between XSAVE capable processors and older processors.
> The decision is not really task specific; instead we use the task status to
> avoid a global memory reference - the value should be the same across all
> threads.
>
> Eliminate this tie-in into the task structure by using an alternative
> instruction keyed off the XSAVE cpu feature; this results in shorter and
> faster code, without introducing a global memory reference.

I think you should either just use cpu_has_xsave, or extend this use
of alternatives to all cpu features.  It doesn't make sense to only do
it for xsave.

--
Brian Gerst
