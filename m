Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab1CXLjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:39:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42442 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab1CXLjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BPRCZRXwT0ngpd3eBTV1YOqGpT+8t68G+03lQ6gJsYIFrG11rUJAmqOCgPCvfAU4hs
         9Cbn9WzEJ2dz/twVJNp/8hDHybNBX50DjpvNjtNa8evW0lLkFT8wmZYzmMnkDhVrNa5t
         raXMFflSDn0O1CXJhqegrg5obT8hGaXkgDMS8=
MIME-Version: 1.0
In-Reply-To: <1300894067-604408-9-git-send-email-hans.rosenfeld@amd.com>
References: <1299698102-972771-9-git-send-email-hans.rosenfeld@amd.com>
	<1300894067-604408-9-git-send-email-hans.rosenfeld@amd.com>
Date: Thu, 24 Mar 2011 07:39:13 -0400
Message-ID: <AANLkTin6XrHKR6ARwC0v4b1URaB=08MD7fUoPap+9Dfb@mail.gmail.com>
Subject: Re: [RFC v2 8/8] x86, xsave: remove lazy allocation of xstate area
From: Brian Gerst <brgerst@gmail.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        eranian@google.com, robert.richter@amd.com, Andreas.Herrmann3@amd.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:27 AM, Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> This patch completely removes lazy allocation of the xstate area. All
> tasks will always have an xstate area preallocated, just like they
> already do when non-lazy features are present. The size of the xsave
> area ranges from 112 to 960 bytes, depending on the xstates present and
> enabled. Since it is common to use SSE etc. for optimization, the actual
> overhead is expected to negligible.
>
> This removes some of the special-case handling of non-lazy xstates. It
> also greatly simplifies init_fpu() by removing the allocation code, the
> check for presence of the xstate area or init_fpu() return value.
>
> Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>

I'm not sure I like this.  I did a quick test on 64-bit, and found
that while most if not all user processes allocated the fpu save area
(probably because of glibc blindly initializing the fpu), kernel
threads did not.  This patch would force kernel threads to allocate
memory they would never use.

--
Brian Gerst
