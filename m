Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab2GCHU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:20:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47864 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab2GCHUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:20:53 -0400
X-AuditID: cbfee61a-b7f086d000000e64-fc-4ff29d53ee9d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Barry Song'" <Barry.Song@csr.com>, mina86@mina86.com
Cc: workgroup.linux@csr.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Barry Song'" <Baohua.Song@csr.com>
References: <1331120259-30780-1-git-send-email-Barry.Song@csr.com>
In-reply-to: <1331120259-30780-1-git-send-email-Barry.Song@csr.com>
Subject: RE: [PATCH v4] mm: cma: add a simple kernel module as the helper to
 test CMA
Date: Tue, 03 Jul 2012 09:20:29 +0200
Organization: SPRC
Message-id: <03e601cd58ec$5b8177b0$12846710$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz8VuI90ZBG4bKpTUGVoKqAInvzzxclE6Rg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd3guZ/8DV7csbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZrx+8Zy04zlMx7dJ51gbG75xdjJwcEgImEtteLGSGsMUkLtxb
	z9bFyMUhJDCdUeLt6eWMEM4sJonWq3NYQarYBAwlut52sYHYIgIWEpP2nAPrYBZoZZTo2d7E
	ApIQEnCSmPV+ChOIzSngLLGw8xF7FyMHh7BAuMT+VeYgYRYBVYkdx/aygYT5BYQkJs5SAAnz
	CrhI/No6jQ3CFpT4Mfke2ERmAS2J9TuPM0HY8hKb17xlBmmVEFCXePRXF+IaI4kr214zQ5SI
	SNxteM46gVF4FpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBIf3
	M6kdjCsbLA4xCnAwKvHwJs7+5C/EmlhWXJl7iFGCg1lJhDfuyEd/Id6UxMqq1KL8+KLSnNTi
	Q4zSHCxK4rxN1hf8hQTSE0tSs1NTC1KLYLJMHJxSDYy1knwviibaL4ph2Xvx7C/DB690lhlH
	RCZL6OuuFGLluhvfU/x8pfmOh083hIkdXLju65unefxeX/+wvV+3u+qg0/mSrNA/3Js2fMvf
	M01pqdU/l5U1R1MaruoU2pTK7Htz+9RivUInyV7udZWxv6MO6N0y3NK1acth12MlbzuMS09x
	XDV4ueCZEktxRqKhFnNRcSIA6BW67WsCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, March 07, 2012 12:38 PM Barry Song wrote:

> From: Barry Song <Baohua.Song@csr.com>
> 
> Any write request to /dev/cma_test will let the module to allocate memory from
> CMA, for example:
> 
> 1st time
> $ echo 1024 > /dev/cma_test
> will require cma_test to request 1MB(1024KB)
> 2nd time
> $ echo 2048 > /dev/cma_test
> will require cma_test to request 2MB(2048KB)
> 
> Any read request to /dev/cma_test will let the module to free the 1st valid
> memory from CMA, for example:
> 
> 1st time
> $ cat /dev/cma_test
> will require cma_test to free the 1MB allocated in the first write request
> 2nd time
> $ cat /dev/cma_test
> will require cma_test to free the 2MB allocated in the second write request
> 
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> ---
>  tools/cma/Makefile   |   13 +++++
>  tools/cma/cma_test.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++

I'm sorry for such a long delay in processing this patch, but I wanted first to be sure
that the core CMA code gets into mainline, then I got busy with other dma-mapping 
related stuff. 

IMHO the right place for such code is in drivers/misc instead of tools/cma. 

This patch contains a kernel module source code so it should be put with other kernel
modules. tools/ directory is aimed to contain user space code useful for developing and
testing Linux kernel.

Make sure that you also add Greg Kroah-Hartman <gregkh@linuxfoundation.org> on CC:,
he maintains misc drivers.

> (snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


