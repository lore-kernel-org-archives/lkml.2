Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab2LaPii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 10:38:38 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:37466 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2LaPig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 10:38:36 -0500
Date: Mon, 31 Dec 2012 19:38:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Eric Paris <eparis@redhat.com>
Cc: Andrew Vagin <avagin@parallels.com>, Andrey Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] prctl: fix validation of an address
Message-ID: <20121231153833.GA11523@moon>
References: <1356778810-20879-1-git-send-email-avagin@openvz.org>
 <1356904987.9725.10.camel@localhost>
 <20121231101414.GA27119@paralelels.com>
 <1356964034.31923.12.camel@localhost>
 <20121231151356.GA11118@moon>
 <1356967247.31923.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356967247.31923.14.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 10:20:47AM -0500, Eric Paris wrote:
> 
> Is there anything which prevents an unpriv application from changing
> mm.mm_start_code and mm.mm_end_code in the image, thus taking advantage
> of the privileged restore code to bypass the mmap_min_addr
> restrictions? 

Well, you can assign some values in image directly (note the crtools
is running with root priveleges and image files have appropriate
owner:group) because image format is opened and well known from
crtools source code or from protobufer files we use to descibe the
entries in image. Thus it's assumed that administrator/root guarantee
that images are not modified after checkpoint (image signing,
checksumming and such). Also note the members being assigned in
this prctl call are not critical but rather used for statistics
output in procfs as far as I remember.

	Cyrill
