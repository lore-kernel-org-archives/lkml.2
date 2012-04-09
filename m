Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2DIRAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:00:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57129 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2DIRAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:00:18 -0400
MIME-Version: 1.0
In-Reply-To: <4F830F64.8000703@redhat.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	<8762d9v10x.fsf@turtle.gmx.de>
	<4F8306ED.7080405@redhat.com>
	<87398cev3j.fsf@turtle.gmx.de>
	<4F830F64.8000703@redhat.com>
Date: Mon, 9 Apr 2012 20:00:17 +0300
X-Google-Sender-Auth: r63_q8rzuzoBF_bXv1izyPYZ31k
Message-ID: <CAOJsxLE0ADd8PvXv+tGadLf3oqi-7SBNtHQsP6manoEMCDPOnA@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 7:33 PM, Rik van Riel <riel@redhat.com> wrote:
>> Attaching these files, since I can't really make anything out of the
>> latter.  Note that I started a few memory hogs (X, Firefox, Emacs with
>> Gnus), so overall memory footprint has grown to 768 MB.
>
> Looks like the "missing" 400MB is all in filesystem caches,
> specifically the dentry cache, the ext4 inode cache and
> buffer heads.
>
> That is perfectly fine, since those caches will be shrunk
> when the system needs memory.

CONFIG_SLUB, right? It will merge caches so you don't necessarily see
leaks in /proc/slabinfo. You can use "slub_nomerge" kernel parameter
to disable the merging.
