Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0JEPoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:44:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457Ab0JEPoG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:44:06 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Oct 2010 08:43:15 -0700
Message-ID: <AANLkTimEp8rorHxtOQji-xtXZoDkcYrGGWCBQg3ypKf4@mail.gmail.com>
Subject: Re: [PATCH 0/1] wait: using uninitialized member of wait queue
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: akpm@linux-foundation.org, m.nazarewicz@samsung.com, mingo@elte.hu,
        gregkh@suse.de, a.p.zijlstra@chello.nl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 1:47 AM, Evgeny Kuznetsov
<EXT-Eugeny.Kuznetsov@nokia.com> wrote:
>
> Here is patch which fixes bug in /include/linux/wait.h file.
> Member "flags" of "wait_queue_t" struct  is used in several places in
> kernel code without beeing initialized. "flags" is used in bitwise
> operations. If it contain dummy data then incorrect flags may be
> used later in code.

The patch looks fine, but do you have any case of this actually
causing problems? Afaik, we do end up initializing the part of the
flags field we care about (WQ_FLAG_EXCLUSIVE) in prepare_to_wait()
(and add_wait_queue()), so it looks - from an admittedly very cursory
read - as if this is a good cleanup but shouldn't actually be the
cause of any actual bugs.

So I'll apply it, but I just wondered if you had actually seen any
semantic changes from it?

               Linus
