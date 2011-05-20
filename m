Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935389Ab1ETIyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:54:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57300 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934991Ab1ETIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Ape04pPXBxhWBR2tNAZ2i5dh/0wyTJZqaJuod7dotHMB6K84hJN2TwUmBfkhXPTYs5
         Z+McZDFhIwfZCTQHpyaApT93p1fZxfZyQiP5kSixHie2r6dtRk51kYLA1OSEcxXwiFdo
         R/0c3E4omKQoR1LWM6sEsFvOGRncCtZ7fghYE=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: "viro\@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw\@canonical.com" <apw@canonical.com>,
        "nbd\@openwrt.org" <nbd@openwrt.org>, "neilb\@suse.de" <neilb@suse.de>,
        "hramrach\@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp\@gmail.com" <jordipujolp@gmail.com>
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
	<D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu>
Date: Fri, 20 May 2011 10:54:21 +0200
In-Reply-To: <D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu> (Erez
	Zadok's message of "Fri, 20 May 2011 01:39:37 -0400")
Message-ID: <87wrhlah1e.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok <ezk@fsl.cs.sunysb.edu> writes:

> I tried your overlayfs.v9 git repo w/ racer, using two separate ext3
> filesystems (one for lowerdir and another for upperdir).  I got the
> WARN_ON in ovl_permission to trigger within about 10 minutes of
> testing.  Looking at the code, I see a problem in returning w/o
> cleaning up an dput-ing the alias dentry.  Simple patch enclosed
> below.

Hmm, thanks.  The more interesting question is: why does that WARN_ON
trigger?  I'll look into it.

Thanks,
Miklos
