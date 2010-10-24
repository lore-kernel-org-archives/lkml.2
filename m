Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab0JXQb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab0JXQb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:31:27 -0400
Message-ID: <4CC45F56.7010305@redhat.com>
Date: Sun, 24 Oct 2010 18:31:18 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: dave b <db.pub.mail@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: Fwd: [dm-crypt] [BUG] bad performance and system stalls when
 using dm-crypt
References: <AANLkTinbeAn4ObFSb4f4znjYHGNKTMnfV7eQja+cnsLe@mail.gmail.com> <20100911065725.GA6279@fancy-poultry.org> <AANLkTikTq=GTy-XPD6ye6kStASNL4Pa07wHhH_ABmpm1@mail.gmail.com> <AANLkTim7RvpOcBajyqCkrBP8EW-FwNysvwuF5MaDJiFV@mail.gmail.com> <AANLkTi=PCd1=w-mkc=Sj4EEda=PnTv0JGyV1Ysxq4ej4@mail.gmail.com> <AANLkTikLSFFpbgX+rBR5banBygmB6rRvzMBYKfPcFPuJ@mail.gmail.com> <4C8C9834.8060201@redhat.com> <AANLkTi=8jJMz3f0VGwg+6P+BJEfxj6i-jBkGmqx8hCVg@mail.gmail.com> <AANLkTinohRReVsYoetEjqAp-XrL9C2jxGgXLVnLafSUM@mail.gmail.com> <AANLkTikqhMbW7sWbbU_we5YE9Y9U=MPUTm553AmCyH51@mail.gmail.com>
In-Reply-To: <AANLkTikqhMbW7sWbbU_we5YE9Y9U=MPUTm553AmCyH51@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2010 05:32 PM, dave b wrote:
> I am forwarding this to the linux kernel mailing list to see if anyone
> is actually interested with this bug or not. I suspect that the patch
> to allow DM-CRYPT to use multiple cpus(Scale to multiple CPUs) will
> remove most of the problem but *not* all of it. As I previously was
> triggering the bug on a single core system.

Hi,
sorry for not updating the bug. We know about this.

Fix was expected to be based on top of the Andi's dm-crypt per-cpu
patch but unfortunately I found serious problems there
(see this thread http://lkml.org/lkml/2010/10/20/215 )

So there are now several known situations when dm-crypt doesn't
perform as expected (another problem just appeared when using CFQ,
(because dm(-crypt) lost the issuing process reference)
see http://lkml.org/lkml/2010/10/24/59).

Milan
