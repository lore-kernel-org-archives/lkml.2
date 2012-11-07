Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2KGHN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:13:57 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52580 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2KGHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:13:54 -0500
MIME-Version: 1.0
In-Reply-To: <509A078D.8060705@oracle.com>
References: <5099F133.5030305@oracle.com>
	<5099FBAA.6000200@oracle.com>
	<CAGXu5jLpE5kTGGqLqDRwRaEOt+nhpKc52jQFs+rsa+0GVKA-vw@mail.gmail.com>
	<509A078D.8060705@oracle.com>
Date: Tue, 6 Nov 2012 23:13:54 -0800
X-Google-Sender-Auth: 6G1vRub5wlsbEjOI1eZTJWLt1bw
Message-ID: <CAGXu5jLC9aj3KewbFb2tHoisjvqj4KkMwpA6KiZ7y8k15WWOwA@mail.gmail.com>
Subject: Re: [RESEND PATCH V3] binfmt_elf.c: use get_random_int() to fix
 entropy depleting
From: Kees Cook <keescook@chromium.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <aedilger@gmail.com>,
        John Sobecki <john.sobecki@oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        jakub@redhat.com, drepper@redhat.com,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 11:02 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 11/07/2012 02:21 PM, Kees Cook wrote:
>> I still want to hear at least from Ted about this changes -- we would
>> be potentially increasing the predictability of these bytes...
>
> We would not increasing that if this routine would be used for AT_RANDOM
> only(and if the array keeping aligned to 4 bytes).
> Otherwise, it would be, so let's waiting for further feedbacks.

get_random_int() comes from a different pool than get_random_bytes(),
IIUC. I'd like to hear some convincing reasoning as to why this change
doesn't compromise predictability. :)

-Kees

-- 
Kees Cook
Chrome OS Security
