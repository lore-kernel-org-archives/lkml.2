Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab2ILQGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:06:36 -0400
Received: from relay.parallels.com ([195.214.232.42]:53624 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2ILQGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:06:35 -0400
Message-ID: <5050B336.1090500@parallels.com>
Date: Wed, 12 Sep 2012 20:07:18 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
CC: "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 0/6] fuse: allocate req->pages[] dynamically
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
In-Reply-To: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

So far as no objections appeared, I'll go ahead and replace fuse 
req->page with req->pagevec. It will point to an array of structs:

struct page_vec {
     struct page    *pv_page;
     unsigned int    pv_len;
     unsigned int    pv_offset;
};

instead of 'struct page *' as it used to be. It seems to be what you 
suggested in one of your comments. Are you OK about it?

Thanks,
Maxim

09/07/2012 09:40 PM, Maxim Patlasov пишет:
> Hi,
>
> Currently, any fuse request always includes inline pages[] array of
> FUSE_MAX_PAGES_PER_REQ elements. This is the waste of memory because
> in many cases smaller size would suffice.
>
> The patch-set tries to allocate only as many elements of pages[] array as
> actaully needed. This will be even more useful in the future because of:
>
> 1. Mitsuo's patches making maximum read/write request size tunable.
> 2. My patches optimizing scatter-gather direct IO. To make them simplier I'll
> need to substitute array of 'struct page *' with array of 'struct bio_vec'.
> It would make memory overhead worse if implemented w/o this patch-set.
>
> Thanks,
> Maxim
>

