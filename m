Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0ISRnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 13:43:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab0ISRnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 13:43:23 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang@iksw-muees.de>
To: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB: free coherent buffer into atomic context
Date: Sun, 19 Sep 2010 19:43:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; i686; ; )
References: <711BBECDEF81BA439A6038E213C1DF140957B9F8@ism-mail03.corp.ad.wrs.com> <201009180954.52965.wolfgang@iksw-muees.de> <AANLkTikj01UhkiVrGJg4jgoOtXZ6dJjnwTsskDUVLD_H@mail.gmail.com>
In-Reply-To: <AANLkTikj01UhkiVrGJg4jgoOtXZ6dJjnwTsskDUVLD_H@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009191943.21021.wolfgang@iksw-muees.de>
X-Provags-ID: V02:K0:g8K12EDbOhBk/MCLayBpJTkfLTs/R3EpJgndympfJTp
 1hpLbSxlySIMokbKhQwyGqQzAeDvrJIt/RyBt72ui3+afmESZv
 G5RA5lKOcH8HmKB3GR4gI8kA5fZpgkcRRpPRsuQJb4flajxcQl
 +UxJUs+BaK+PAyOVGrkUrffvbIwmTouS9/1IBqBLFr9s3K2IBK
 MlHZUIrRzramxdpjhxkUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

Am Samstag, 18. September 2010 10:50:20 schrieb Ming Lei:
> IMO, it is not necessary for a coherent buffer to be kept for
> the whole time a driver operates on a device.

>From DMA-mapping.txt:
>There are two types of DMA mappings:
>
>- Consistent DMA mappings which are usually mapped at driver
>  initialization, unmapped at the end and for which the hardware should
>  guarantee that the device and the CPU can access the data
>  in parallel and will see updates made by each other without any
>  explicit software flushing.

>- Streaming DMA mappings which are usually mapped for one DMA transfer,
>  unmapped right after it (unless you use pci_dma_sync_* below) and for which
>  hardware can optimize for sequential accesses.

You wrote:
> Also, coherent buffer
> is very limited in some arch(such as ARM), maybe we should use it
> more dynamically, instead of keeping it for long time.

No, this is against the design (see above).

If you want to be dynamic, please use streaming DMA mapping.

If a DMA buffer is needed often and you want to avoid the overhead of streaming 
dma mapping, use a coherent buffer.

> irqs_disabled() doesn't mean the buffer is freed in an interrupt context.

I am very sure that the writer of this code has used irqs_disabled() as an 
indication of interrupt context. Maybe in_interrupt() will be more precise.

> If it is only a misuse, seems WARN_ON can be removed.

How on earth will you detect the misuse if there is no visible indication at 
runtime?

best regards
Wolfgang
-- 
Wahre Worte sind nicht schön - Schöne Worte sind nicht wahr. (Laotse)
