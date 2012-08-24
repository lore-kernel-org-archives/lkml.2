Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab2HXNTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:19:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42515 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2HXNTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:19:30 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        Tomasz Stanislawski <t.stanislaws@samsung.local>
Subject: Re: [PATCH 2/3] [media] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Fri, 24 Aug 2012 15:23:09 +0200
Message-ID: <1417436.RHVOLNlTxk@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.2-3.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <02f301cd7eaa$4fa7a7a0$eef6f6e0$%szyprowski@samsung.com>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com> <1343765829-6006-3-git-send-email-federico.vaga@gmail.com> <02f301cd7eaa$4fa7a7a0$eef6f6e0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Getting back to your patch - in your approach cpu cache handling is
> missing. I suspect that it worked fine only because it has been
> tested on some simple platform without any cpu caches (or with very
> small ones).

Is missing from the memory allocator because I do it on the device 
driver. The current operations don't allow me to do that in the memory 
allocator.


> Please check the following thread:
> http://www.spinics.net/lists/linux-media/msg51768.html where Tomasz
> has posted his ongoing effort on updating and extending videobuf2 and
> dma-contig allocator. Especially the patch
> http://www.spinics.net/lists/linux-media/msg51776.html will be
> interesting for you, because cpu cache synchronization
> (dma_sync_single_for_device / dma_sync_single_for_cpu) should be
> called from prepare/finish callbacks.

You are right, it is interesting because avoid me to use cache sync in 
my driver. Can I work on these patches?

>From this page I understand that these patches are not approved yet
https://patchwork.kernel.org/project/linux-media/list/?page=2

-- 
Federico Vaga
