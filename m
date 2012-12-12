Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2LLRNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:13:19 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53914 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2LLRNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:13:15 -0500
MIME-Version: 1.0
X-Originating-IP: [63.163.107.100]
In-Reply-To: <CAJAFBLD9qETdS+6YovpSR2xQHktSdJWk-FmDJ-mJFJfx=3_M4Q@mail.gmail.com>
References: <1355323077-5803-1-git-send-email-linkinjeon@gmail.com>
 <CAJAFBLDE1k+sj4_FpjhSnaVF43twY2RRg=JsbdVVQOT0L4BPEw@mail.gmail.com>
 <CALq1K=J_tDiUoQ2u384KjCqPe6YWzRCL=HJbsgkEOfXug4DOhA@mail.gmail.com> <CAJAFBLD9qETdS+6YovpSR2xQHktSdJWk-FmDJ-mJFJfx=3_M4Q@mail.gmail.com>
From: Leon Romanovsky <leon@leon.nu>
Date: Wed, 12 Dec 2012 09:12:54 -0800
Message-ID: <CALq1K=+uWpQ4kzx_FOaH8f=xbtYZP9-Vooh2rwDSp6u6W_H7ew@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
To: Fubo Chen <fubo.chen@gmail.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, jaegeuk.kim@samsung.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 8:50 AM, Fubo Chen <fubo.chen@gmail.com> wrote:
> On Wed, Dec 12, 2012 at 5:12 PM, Leon Romanovsky <leon@leon.nu> wrote:
>> On Wed, Dec 12, 2012 at 7:05 AM, Fubo Chen <fubo.chen@gmail.com> wrote:
>>>
>>> On Wed, Dec 12, 2012 at 3:37 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>>> > +       /* dot and dotdot dentries should have zero-value hash code */
>>> > +       if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
>>> > +               return 0;
>>>
>>> That looks suspicious. If memcmp(name, "..", 2) == 0 then always
>>> memcmp(name, ".", 1) == 0. Why two tests ?
>>
>> It is not the case vice versa, so you still need to do two checks.
>> You need to distinguish dot(.), dotdot(..) and something with dot at
>> the beginning (for example - .o)
>
> Thanks for replying. I understand that the intention is what you
> explained. But to me the code says something else: "if the first byte
> of name is a dot, return 0". Did I see that correctly ?
Excellent catch, I agree with you It will also return 0 for every file
which starts from the dot.
The right solution must take name length into account.

>
> Fubo.



-- 
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu
