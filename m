Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1KOLXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:23:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42395 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab1KOLXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:23:32 -0500
MIME-Version: 1.0
In-Reply-To: <1321346525-10187-1-git-send-email-amwang@redhat.com>
References: <1321346525-10187-1-git-send-email-amwang@redhat.com>
Date: Tue, 15 Nov 2011 13:23:31 +0200
X-Google-Sender-Auth: 2g0xmmZkobmCTXMzYdcf0rKpmiM
Message-ID: <CAOJsxLEXbWbEhqX2YfzcQhyLJrY0H2ifCJCvGkoFHZsYAZEMPA@mail.gmail.com>
Subject: Re: [Patch] tmpfs: add fallocate support
From: Pekka Enberg <penberg@kernel.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 15, 2011 at 10:42 AM, Amerigo Wang <amwang@redhat.com> wrote:
> This patch adds fallocate support to tmpfs. I tested this patch
> with the following test case,
>
>        % sudo mount -t tmpfs -o size=100 tmpfs /mnt
>        % touch /mnt/foobar
>        % echo hi > /mnt/foobar
>        % fallocate -o 3 -l 5000 /mnt/foobar
>        fallocate: /mnt/foobar: fallocate failed: No space left on device
>        % fallocate -o 3 -l 3000 /mnt/foobar
>        % ls -l /mnt/foobar
>        -rw-rw-r-- 1 wangcong wangcong 3003 Nov 15 16:10 /mnt/foobar
>        % dd if=/dev/zero of=/mnt/foobar seek=3 bs=1 count=3000
>        3000+0 records in
>        3000+0 records out
>        3000 bytes (3.0 kB) copied, 0.0153224 s, 196 kB/s
>        % hexdump -C /mnt/foobar
>        00000000  68 69 0a 00 00 00 00 00  00 00 00 00 00 00 00 00  |hi..............|
>        00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>        *
>        00000bb0  00 00 00 00 00 00 00 00  00 00 00                 |...........|
>        00000bbb
>        % cat /mnt/foobar
>        hi
>
> Signed-off-by: WANG Cong <amwang@redhat.com>

What's the use case for this?

                        Pekka
