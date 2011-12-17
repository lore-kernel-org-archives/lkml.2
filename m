Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1LQSj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 13:39:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58286 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1LQSjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 13:39:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAMzpN2inHxaSnaYaYXZ4Ya3rK+MWXqR6dN5NVNZy3=OvP04uQA@mail.gmail.com>
References: <201112172258.24221.nai.xia@gmail.com> <CAMzpN2inHxaSnaYaYXZ4Ya3rK+MWXqR6dN5NVNZy3=OvP04uQA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 17 Dec 2011 10:39:03 -0800
X-Google-Sender-Auth: 5V4PJFY880rbLZZDZyouFOS06J0
Message-ID: <CA+55aFzyEgDUSaNVQ1Nw5SBNd36Cvb-KrVdc1MYj+oRJt8xWgg@mail.gmail.com>
Subject: Re: Question about missing "cld" in x86 string assembly code
To: Brian Gerst <brgerst@gmail.com>
Cc: nai.xia@gmail.com, Andi Kleen <ak@linux.intel.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 17, 2011 at 9:08 AM, Brian Gerst <brgerst@gmail.com> wrote:
>
> The i386 ELF ABI states "The direction flag must be set to the
> ‘‘forward’’ (that is, zero) direction before entry and upon exit from
> a function."  Therefore it can be assumed to be clear, unless
> explicitly set.

The exception, of course, being bootup, fault and interrupt handlers,
and after we've called out to foreign code (ie BIOS).

So there *are* a few cld's sprinkled around, they are just fairly rare.

                    Linus
