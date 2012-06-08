Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2FHAmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:42:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35345 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2FHAmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120608003604.GK30000@ZenIV.linux.org.uk>
References: <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk> <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com> <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk> <873966n2c2.fsf@xmission.com>
 <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com> <20120608003604.GK30000@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 17:42:02 -0700
X-Google-Sender-Auth: 1sIUw4z475Fparlb4zyshj_v95M
Message-ID: <CA+55aFwvtdJsFEit4N3OVKZH2jpvxnB9843nhQeqGu99aUOQpw@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 5:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Frankly, I would very much prefer to have the same locking rules wherever
> possible.  The locking system is already overcomplicated and making its
> analysis fs-dependent as well... <shudder>

I do agree that it would be better if we avoid it. I was just trying
to explain that the dentry locking is *not* enough, for the simple
reason that it relies on upper-level non-dentry locking just to work.

Your patch looks good, but whether it works I have no idea ;)

               Linus
