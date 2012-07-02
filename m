Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2GBB0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:26:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58555 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2GBB0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+8KMdX92T6Ma8HBXko4BHGmZKcV1kuR+b38r00r6YZbw@mail.gmail.com>
References: <1340658327-2932-1-git-send-email-keescook@chromium.org>
	<1340658327-2932-2-git-send-email-keescook@chromium.org>
	<20120630091422.GE14083@ZenIV.linux.org.uk>
	<CAGXu5j+8KMdX92T6Ma8HBXko4BHGmZKcV1kuR+b38r00r6YZbw@mail.gmail.com>
Date: Sun, 1 Jul 2012 18:26:38 -0700
X-Google-Sender-Auth: G6ANy6l1HNa0pIJhnhWMxEpsLLM
Message-ID: <CAGXu5jL45EWVr9PfhF6vpb-PmHPZLOC9Dao_MKpjx2LBhbzKOg@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: add link restrictions
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>,
        Joe Korty <joe.korty@ccur.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 1, 2012 at 5:43 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Jun 30, 2012 at 2:14 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Mon, Jun 25, 2012 at 02:05:26PM -0700, Kees Cook wrote:
>>> +                     err = may_follow_link(&link);
>>> +                     if (unlikely(err))
>>> +                             break;
>>
>> No.  This is definitely wrong - you are leaking dentries and vfsmount here.
>
> What should I do to avoid the leak? I thought it was avoiding the need
> to call put_link because it aborts before calling follow_link.

Does this need "path_put(&nd->path);" added to the abort case?

If so, is this also missing from follow_link()'s final "return error",
or is it the responsibility of dentry->d_inode->i_op->follow_link() to
have already called path_put()?

-Kees

-- 
Kees Cook
Chrome OS Security
