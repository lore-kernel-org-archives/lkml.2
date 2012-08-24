Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab2HXNkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:40:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51490 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2HXNkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:40:52 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-e7-503784627b33
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Federico Vaga'" <federico.vaga@gmail.com>
Cc: "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
 <1343765829-6006-3-git-send-email-federico.vaga@gmail.com>
 <02f301cd7eaa$4fa7a7a0$eef6f6e0$%szyprowski@samsung.com>
 <1417436.RHVOLNlTxk@harkonnen>
In-reply-to: <1417436.RHVOLNlTxk@harkonnen>
Subject: RE: [PATCH 2/3] [media] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Date: Fri, 24 Aug 2012 15:40:38 +0200
Organization: SPRC
Message-id: <027701cd81fe$0ed356a0$2c7a03e0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2B+xrMC9Jyc9knTkC0GiicAKDPOQAAmKNQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jQd2kFvMAg57fihaXd81hs+jZsJXV
	gcnj8ya5AMYoLpuU1JzMstQifbsErow9n5cwF/zlqfj1fyt7A+Nhri5GTg4JAROJr1teMEPY
	YhIX7q1n62Lk4hASmM4oMal/FiOE85NRYvb0bkaQKjYBQ4mut11sILaIgK5ET28PC0gRs8Ax
	Jom2V20sEB33GSWePlzJClLFKaAt8br5NNgOYYEoiRP7QDo4OVgEVCXWnGsEmsrBwS8gJDFx
	lgJImFfARaL3/D52CFtQ4sfke2DlzAJaEut3HmeCsOUlNq95ywzSKiGgLvHory7EPUYS3yYf
	gyoRkbjb8Jx1AqPwLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CA72Z1I7GFc2WBxiFOBgVOLh3dFiFiDEmlhWXJl7iFGCg1lJhFfAzzxAiDclsbIqtSg/vqg0
	J7X4EKM0B4uSOC9/n2GAkEB6YklqdmpqQWoRTJaJg1OqgbG6Jfv7tlP6zcvso+LOscw29RP6
	4RjvrRgeuEcivEmY12hHowiHnci6Jfsi+faknmN7fXDiwalcE14fkfIzSJx1zTvsbZ7t8ohi
	J29hgZ7ogrm93x+y7qhlX3rQaQcfu1XMekvxRp2guWznLYXFn26IYlH0tGj89dAwzWpVDNu3
	ettn76NvK7EUZyQaajEXFScCADtbwwNyAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, August 24, 2012 3:23 PM Federico Vaga wrote:

> > Getting back to your patch - in your approach cpu cache handling is
> > missing. I suspect that it worked fine only because it has been
> > tested on some simple platform without any cpu caches (or with very
> > small ones).
> 
> Is missing from the memory allocator because I do it on the device
> driver. The current operations don't allow me to do that in the memory
> allocator.

Memory allocator module is much more appropriate place for it. dma-sg
allocator also needs a huge cleanup in this area...

> > Please check the following thread:
> > http://www.spinics.net/lists/linux-media/msg51768.html where Tomasz
> > has posted his ongoing effort on updating and extending videobuf2 and
> > dma-contig allocator. Especially the patch
> > http://www.spinics.net/lists/linux-media/msg51776.html will be
> > interesting for you, because cpu cache synchronization
> > (dma_sync_single_for_device / dma_sync_single_for_cpu) should be
> > called from prepare/finish callbacks.
> 
> You are right, it is interesting because avoid me to use cache sync in
> my driver. Can I work on these patches?
> 
> From this page I understand that these patches are not approved yet
> https://patchwork.kernel.org/project/linux-media/list/?page=2

You can take the patch which adds prepare/finish methods to memory
allocators. It should not have any dependency on the other stuff from
that thread. I'm fine with merging it either together with Your patch
or via Tomasz's patchset, whatever comes first.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


