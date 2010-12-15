Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0LOLW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 06:22:28 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36808 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0LOLW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 06:22:27 -0500
To: Hugh Dickins <hughd@google.com>
CC: miklos@szeredi.hu, akpm@linux-foundation.org, robert@swiecki.net,
        lkml20101129@newton.leun.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-reply-to: <alpine.LSU.2.00.1012142020030.12693@tigran.mtv.corp.google.com>
	(message from Hugh Dickins on Tue, 14 Dec 2010 20:32:49 -0800 (PST))
Subject: Re: kernel BUG at mm/truncate.c:475!
References: <20101130194945.58962c44@xenia.leun.net> <alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com> <E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu> <20101201124528.6809c539@xenia.leun.net> <E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>
 <20101202084159.6bff7355@xenia.leun.net> <20101202091552.4a63f717@xenia.leun.net> <E1PO5gh-00079U-Ma@pomaz-ex.szeredi.hu> <20101202115722.1c00afd5@xenia.leun.net> <20101203085350.55f94057@xenia.leun.net> <E1PPaIw-0004pW-Mk@pomaz-ex.szeredi.hu>
 <20101206204303.1de6277b@xenia.leun.net> <E1PRQDn-0007jZ-5S@pomaz-ex.szeredi.hu> <20101213142059.643f8080.akpm@linux-foundation.org> <E1PSSO8-0003sy-Vr@pomaz-ex.szeredi.hu> <alpine.LSU.2.00.1012142020030.12693@tigran.mtv.corp.google.com>
Message-Id: <E1PSpQw-0005s5-QW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 15 Dec 2010 12:22:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, Hugh Dickins wrote:
> I'd feel rather happier about it if I thought it would also fix
> Robert's kernel BUG at /build/buildd/linux-2.6.35/mm/filemap.c:128!
> but I've still not found time to explain that one.

Me neither, all unmap_mapping_range() calls from shmfs are either with
i_mutex or from evict_inode.

Hmm, is there anything preventing remap_file_pages() installing a pte
at an address that unmap_mapping_range() has already processed?

Thanks,
Miklos
