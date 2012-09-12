Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab2ILQTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:19:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33987 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2ILQTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:19:21 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [PATCH 2/6] fuse: categorize fuse_get_req()
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
	<20120907174112.1343.95512.stgit@maximpc.sw.ru>
Date: Wed, 12 Sep 2012 18:20:57 +0200
In-Reply-To: <20120907174112.1343.95512.stgit@maximpc.sw.ru> (Maxim Patlasov's
	message of "Fri, 07 Sep 2012 21:41:19 +0400")
Message-ID: <87392nxlee.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Patlasov <mpatlasov@parallels.com> writes:

> The patch categorizes all fuse_get_req() invocations into three categories:
>  - fuse_get_req_nopages() - when caller doesn't care about req->pages
>  - fuse_get_req_onepage() - when caller need exactly one page
>  - fuse_get_req_multipage() - in other cases.

I think you are overcomplicating this.

Just have two functions: fuse_get_req_nopages() and fuse_get_req().

I don't think the _onepage variant deserves a separate helper.

Thanks,
Miklos
