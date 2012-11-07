Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2KGE3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:29:35 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59434 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2KGE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:29:34 -0500
MIME-Version: 1.0
In-Reply-To: <5099E1C7.5000007@oracle.com>
References: <20121107001609.9B7A9100047@wpzn3.hot.corp.google.com>
	<CAGXu5jJ779UvpZwO-fi7-m+i=OfqwgXh1PC4GNwjhfD9GD82wQ@mail.gmail.com>
	<5099E1C7.5000007@oracle.com>
Date: Tue, 6 Nov 2012 20:29:33 -0800
X-Google-Sender-Auth: 33wHleHFlaZZNrZTE00KKUk9Skc
Message-ID: <CAGXu5j+fLM4YV==xjTsS4qU+CZY_ohL2cdAcEcXBjmS2WHa6Sw@mail.gmail.com>
Subject: Re: + binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
 added to -mm tree
From: Kees Cook <keescook@chromium.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: akpm@linux-foundation.org, aedilger@gmail.com, alan@linux.intel.com,
        arnn@arndb.de, gregkh@linuxfoundation.org, jakub@redhat.com,
        james.l.morris@oracle.com, john.sobecki@oracle.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 8:21 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> Hi Andrew and Kees,
>
> Great thanks for both your comments!
>
> On 11/07/2012 09:11 AM, Kees Cook wrote:
>> Hrm, I don't like this. get_random_int() specifically says: "Get a
>> random word for internal kernel use only." The intent of AT_RANDOM is
>> for userspace pRNG seeding (though glibc currently uses it directly
>> for stack protector and pointer mangling), which is not "internal
>> kernel use only". :) Though I suppose this is already being used for
>> the randomize_stack_top(), but I think it'd still be better to use
>> higher quality bits.
> Btw Kees, does it sounds make sense if we just return the 16 bytes
> uninitialized stack array if the user disable the stack randomize via
> "/proc/sys/kernel/randomize_va_space = 0" or via the related sysctl, or
> even specified norandmaps on boot?

No, I feel that ASLR (randomize_va_space) is distinctly separate from
how glibc uses AT_RANDOM (stack protector and pointer mangling).
AT_RANDOM should remain active even if randomize_va_space is 0.

-Kees

-- 
Kees Cook
Chrome OS Security
