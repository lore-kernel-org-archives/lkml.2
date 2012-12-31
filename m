Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2LaVMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 16:12:06 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:48482 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2LaVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 16:12:05 -0500
Date: Mon, 31 Dec 2012 21:12:46 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>, Andrew Vagin <avagin@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] prctl: fix validation of an address
Message-ID: <20121231211246.GA784@mail.hallyn.com>
References: <1356778810-20879-1-git-send-email-avagin@openvz.org>
 <1356904987.9725.10.camel@localhost>
 <20121231101414.GA27119@paralelels.com>
 <1356964034.31923.12.camel@localhost>
 <20121231151356.GA11118@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231151356.GA11118@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> > The kernel makes the decision on what is valid via security_mmap_addr().
> > Assuming there are no security fears of an untrusted application
> > tricking some priviledged application to set up these maps the answer is
> > just calling security_mmap_addr() instead of doing if(addr <
> > mmap_min_addr) return -EINVAL;
> 
> If only I've not missed something obvious, the check for security_mmap_addr() here
> instead of poking the mmap_min_addr looks more correct for me. Andrew?

That sounds right to me as well.

-serge
