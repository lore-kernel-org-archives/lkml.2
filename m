Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2JPCfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:35:16 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40729 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2JPCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:35:15 -0400
MIME-Version: 1.0
In-Reply-To: <20121008150949.GA15130@redhat.com>
References: <20121008150949.GA15130@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 15 Oct 2012 22:34:53 -0400
Message-ID: <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com>
Subject: Re: mpol_to_str revisited.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 11:09 AM, Dave Jones <davej@redhat.com> wrote:
> Last month I sent in 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a to remove
> a user triggerable BUG in mempolicy.
>
> Ben Hutchings pointed out to me that my change introduced a potential leak
> of stack contents to userspace, because none of the callers check the return value.
>
> This patch adds the missing return checking, and also clears the buffer beforehand.

I don't think 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a is right fix. we should
close a race (or kill remain ref count leak) if we still have.
Because of, this patch makes unstable /proc output and might lead to
userland confusing.
