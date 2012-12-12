Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2LLQv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:51:27 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57523 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab2LLQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <CALq1K=J_tDiUoQ2u384KjCqPe6YWzRCL=HJbsgkEOfXug4DOhA@mail.gmail.com>
References: <1355323077-5803-1-git-send-email-linkinjeon@gmail.com>
	<CAJAFBLDE1k+sj4_FpjhSnaVF43twY2RRg=JsbdVVQOT0L4BPEw@mail.gmail.com>
	<CALq1K=J_tDiUoQ2u384KjCqPe6YWzRCL=HJbsgkEOfXug4DOhA@mail.gmail.com>
Date: Wed, 12 Dec 2012 17:50:16 +0100
Message-ID: <CAJAFBLD9qETdS+6YovpSR2xQHktSdJWk-FmDJ-mJFJfx=3_M4Q@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Fubo Chen <fubo.chen@gmail.com>
To: Leon Romanovsky <leon@leon.nu>
Cc: Namjae Jeon <linkinjeon@gmail.com>, jaegeuk.kim@samsung.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 5:12 PM, Leon Romanovsky <leon@leon.nu> wrote:
> On Wed, Dec 12, 2012 at 7:05 AM, Fubo Chen <fubo.chen@gmail.com> wrote:
>>
>> On Wed, Dec 12, 2012 at 3:37 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> > +       /* dot and dotdot dentries should have zero-value hash code */
>> > +       if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
>> > +               return 0;
>>
>> That looks suspicious. If memcmp(name, "..", 2) == 0 then always
>> memcmp(name, ".", 1) == 0. Why two tests ?
>
> It is not the case vice versa, so you still need to do two checks.
> You need to distinguish dot(.), dotdot(..) and something with dot at
> the beginning (for example - .o)

Thanks for replying. I understand that the intention is what you
explained. But to me the code says something else: "if the first byte
of name is a dot, return 0". Did I see that correctly ?

Fubo.
