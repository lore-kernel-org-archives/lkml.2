Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2BCR05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:26:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48228 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab2BCR04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:26:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120203171045.GK11834@moon>
References: <20120203151928.474036973@openvz.org>
	<20120203152650.894621377@openvz.org>
	<CAGXu5jKsFoMS4XgfOQBZYabrD_5BJAyaXn=5tW9xFd4GuBXTQg@mail.gmail.com>
	<20120203171045.GK11834@moon>
Date: Fri, 3 Feb 2012 09:26:55 -0800
X-Google-Sender-Auth: a7Wfb24p9NBac5eu-mbMb2fG1cs
Message-ID: <CAGXu5jJxJ5QfFt-iMxwuyyu_atER=3QzVtfikbHwDyuf55PD+g@mail.gmail.com>
Subject: Re: [patch 4/4] c/r: prctl: Extend PR_SET_MM to set up more mm_struct entries
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 9:10 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Fri, Feb 03, 2012 at 08:56:20AM -0800, Kees Cook wrote:
>> On Fri, Feb 3, 2012 at 7:19 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> > +       case PR_SET_MM_AUXV: {
>> > +               unsigned long user_auxv[AT_VECTOR_SIZE];
>> > +
>> > +               if (arg4 > sizeof(mm->saved_auxv))
>> > +                       goto out;
>>
>> While these are both AT_VECTOR_SIZE, I think it might be better to use
>> sizeof(mm->saved_auxv) instead of AT_VECTOR_SIZE, just so that they
>> can never get out sync and there's a single reference for the size.
>>
>
> I suppose you meant ARRAY_SIZE rather since plain sizeof will give you
> the summary size in bytes, but I think I have better idea -- lets put
> BUILD_BUG_ON here, like below.

Ah, cool. Works for me. :)

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
ChromeOS Security
