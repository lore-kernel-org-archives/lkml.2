Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1GZQiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:38:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab1GZQhx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:37:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110726161831.GA6704@infradead.org>
References: <20110725185649.GA22133@ZenIV.linux.org.uk> <20110726033535.GA11939@x4.trippels.de>
 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
 <20110726082146.GB11939@x4.trippels.de> <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
 <20110726085804.GA1639@x4.trippels.de> <CA+55aFz0S3mO9ETFZpsEcbotWV+NMzaFhpZcN09LNAdk+eavjg@mail.gmail.com>
 <20110726155930.GB1629@x4.trippels.de> <CA+55aFzxmLvLcEagYqE5iOTRv724ecW3va+Pv_RPsPLKeYHTCA@mail.gmail.com>
 <20110726161831.GA6704@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jul 2011 09:37:01 -0700
Message-ID: <CA+55aFzJUdCgY=p_5tXf2z8_ctGYcwfyj9jYRvABUuu1g58VXA@mail.gmail.com>
Subject: Re: [git pull] vfs pile 1.5
To: Christoph Hellwig <hch@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Liu <lingjiujianke@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 9:18 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> Even getting to check_acl() requires MS_POSIXACL to be set on the
> superblock, which it won't be if CONFIG_XFS_ACL isn't set.

Ahh, ok. That thing is well-hidden behind that IS_POSIXACL() thing..
And it turns out that now that I see it, I shudder. That's another of
those potentially expensive inode indirect pointer accesses - but I
haven't seen it because my normal test-workload is as the owner of the
tree I'm traversing.

> These days we can probably kill CONFIG_FOOFS_ACL given that everyone
> now uses the generic code, and due to the deeper VFS interaction is
> more or less forced to anyway.  Historically that wasn't the case.

Yeah. And these days pretty much every single distribution uses ACL's,
which also didn't use to be the case (or even if they used them, it
wasn't a requirement: now it tends to be).

> While I agree with you that we should life it into the common code,
> the common caching is not related at all to this particular issue.

Yeah, I had missed the hidden MS_POSIX_ACL test.

So I agree, the plain NULL return for "no ACL" works fine.

Do we have a signed-off version with a changelog etc?

                          Linus
