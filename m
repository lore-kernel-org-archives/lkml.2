Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1LBL6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:58:34 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47493 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182Ab1LBL6c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFypH2+MQOZfn8qoO7zo_17Oo8jLaayye45pgo_Hpz2jBQ@mail.gmail.com>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
	<20111201122425.GA16274@localhost>
	<20111201142704.GT4387@parisc-linux.org>
	<CA+55aFypH2+MQOZfn8qoO7zo_17Oo8jLaayye45pgo_Hpz2jBQ@mail.gmail.com>
Date: Fri, 2 Dec 2011 13:58:30 +0200
Message-ID: <CAO9iq9GwoJD0AJnpS8dLXUT_KfTvaWTd4k8MUpACTR4q=zqR3g@mail.gmail.com>
Subject: Re: [PATCH] fs: Make write(2) interruptible by a fatal signal
From: Janne Blomqvist <blomqvist.janne@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 18:10, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Dec 1, 2011 at 6:27 AM, Matthew Wilcox <matthew@wil.cx> wrote:
>>
>> Another problem scenario is an NFS mounted file going away while the
>> user is writing to it.  The user should be able to kill the stuck process
>> without rebooting their machine.
>
> Well, NFS has always had the 'intr' mount option.

For some values of always; My nfs(5) manpage says:

"The intr / nointr mount option is deprecated after kernel 2.6.25.
Only SIGKILL can interrupt a pending NFS operation on these  kernels,
and
if specified, this mount option is ignored to provide backwards
compatibility with older kernels."

(Apparently this was related to the introduction of TASK_KILLABLE.)

Isn't this pretty much the same "common sense" semantics that Jan's
patch is introducing?

Wu's testing in this thread suggests that at some point this
TASK_KILLABLE for nfs writer thing was broken, or didn't work very
robustly to begin with? Anyway, awesome if it's getting fixed, not
only for NFS but for all regular files!

-- 
Janne Blomqvist
