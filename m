Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab2EAOhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 10:37:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52905 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2EAOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 10:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
References: <1335778207-6511-1-git-send-email-jack@suse.cz> <CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 1 May 2012 10:37:20 -0400
Message-ID: <CAHGf_=ojhwPUWJR0r+jVgjNd5h_sRrppzJntSpHzxyv+OuBueg@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
To: Jan Kara <jack@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, Jeff Moyer <jmoyer@redhat.com>,
        npiggin@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
>
> Thank you revisit this. But as far as my remember is correct, this issue is NOT
> unaligned access issue. It's just get_user_pages(_fast) vs fork race issue. i.e.
> DIRECT_IO w/ multi thread process should not use fork().

The problem is, fork (and its COW logic) assume new access makes cow break,
But page table protection can't detect a DMA write. Therefore DIO may override
shared page data.
