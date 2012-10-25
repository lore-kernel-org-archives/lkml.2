Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab2JYR7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:59:39 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55694 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab2JYR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:59:37 -0400
MIME-Version: 1.0
In-Reply-To: <20121025175412.GG14085@redhat.com>
References: <20121025152613.GF14085@redhat.com>
	<20121025173326.GH11442@htj.dyndns.org>
	<20121025175412.GG14085@redhat.com>
Date: Thu, 25 Oct 2012 10:59:35 -0700
X-Google-Sender-Auth: e2hTuwwynMDZuO95fVzL-5Z1mOw
Message-ID: <CAOS58YMJBNquaeP7rBzWu8vTWukAT3itH+qSt0cJxMmpTm0YEQ@mail.gmail.com>
Subject: Re: [PATCH] fs: xattr: rewrite simple_xattr_set()
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 25, 2012 at 10:54 AM, Aristeu Rozanski <aris@redhat.com> wrote:
>> So, it returns 0 on success and 1 on failure, which in itself isn't a
>> particularly good idea.
>
> you mean it should return -ENODATA instead?

Yeap, this is a bug, right?  We end up passing that 1 to the set_xattr caller.

-- 
tejun
