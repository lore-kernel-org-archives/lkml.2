Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1IAMgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab1IAMgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:36:41 -0400
Subject: Re: [PATCH 1/3] add dma_coherent_write_sync to DMA API
From: Mark Salter <msalter@redhat.com>
To: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Cc: linux-kernel@vger.kernel.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, linux-arm-kernel@lists.infradead.org
Date: Thu, 01 Sep 2011 08:36:34 -0400
In-Reply-To: <CAHXqBFJ6tEkn+iW3ZBAiWu5Sx9y9MQdnJt5Gfnv5Xc3UB78uLw@mail.gmail.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
	 <1314826214-22428-2-git-send-email-msalter@redhat.com>
	 <CAHXqBFJ6tEkn+iW3ZBAiWu5Sx9y9MQdnJt5Gfnv5Xc3UB78uLw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Message-ID: <1314880595.1439.13.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 11:57 +0200, Micha³ Miros³aw wrote:
> BTW, if there's no time limit on write buffers flushing, or if write
> buffers can cause reordering of the writes, then the memory accesses
> need to be managed just like non-DMA-coherent memory. So what differs
> then in DMA-coherent vs non-DMA-coherent mappings then?

My understanding is that ordering is preserved, but an ARM guy should
probably verify that.

IIUC, the write buffers could hold data indefinitely. As a practical
matter other writes needing to go out to memory will force buffered
data out eventually. Again, this is my understanding which may be
faulty. My feeling is that this extended write buffering makes it
hard to call the dma memory fully coherent, but other limitations on
ARMv7 make the buffering hard to avoid.

--Mark


