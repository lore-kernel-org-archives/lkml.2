Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab2DIRTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:19:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56043 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751672Ab2DIRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:19:12 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+2fNIn8ei23AWtBN2GtyumE+i25hWUokdOFr9OUk
	i2lFL5zkQur7iS
From: Sven Joachim <svenjoac@gmx.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	<8762d9v10x.fsf@turtle.gmx.de> <4F8306ED.7080405@redhat.com>
	<87398cev3j.fsf@turtle.gmx.de> <4F830F64.8000703@redhat.com>
	<CAOJsxLE0ADd8PvXv+tGadLf3oqi-7SBNtHQsP6manoEMCDPOnA@mail.gmail.com>
Date: Mon, 09 Apr 2012 19:19:07 +0200
In-Reply-To: <CAOJsxLE0ADd8PvXv+tGadLf3oqi-7SBNtHQsP6manoEMCDPOnA@mail.gmail.com>
	(Pekka Enberg's message of "Mon, 9 Apr 2012 20:00:17 +0300")
Message-ID: <87mx6kddro.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-09 19:00 +0200, Pekka Enberg wrote:

> On Mon, Apr 9, 2012 at 7:33 PM, Rik van Riel <riel@redhat.com> wrote:
>>> Attaching these files, since I can't really make anything out of the
>>> latter.  Note that I started a few memory hogs (X, Firefox, Emacs with
>>> Gnus), so overall memory footprint has grown to 768 MB.
>>
>> Looks like the "missing" 400MB is all in filesystem caches,
>> specifically the dentry cache, the ext4 inode cache and
>> buffer heads.
>>
>> That is perfectly fine, since those caches will be shrunk
>> when the system needs memory.
>
> CONFIG_SLUB, right?

Actually, no.  For some reason (probably historical…) I have CONFIG_SLAB.

> It will merge caches so you don't necessarily see
> leaks in /proc/slabinfo. You can use "slub_nomerge" kernel parameter
> to disable the merging.

Cheers,
       Sven
