Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337Ab2FEBx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:53:27 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:52482 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757573Ab2FEBxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:53:25 -0400
From: <Tao.Guo@emc.com>
To: <shli@kernel.org>, <glorioustao@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <neilb@suse.de>, <axboe@kernel.dk>,
        <stable@vger.kernel.org>, <akpm@linux-foundation.org>
Date: Mon, 4 Jun 2012 21:48:57 -0400
Subject: RE: [PATCH 1/2] block: Move general unplug callback function from
 md/raid to blk-core
Thread-Topic: [PATCH 1/2] block: Move general unplug callback function from
 md/raid to blk-core
Thread-Index: Ac1CuZmTPjTBUXLlRWad/BeJIdqCdwAAU12Q
Message-ID: <5723ED3022C1484092D8E8139108116905581F3ACF@MX18A.corp.emc.com>
References: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
 <20120605012116.GA357@kernel.org>
In-Reply-To: <20120605012116.GA357@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you ever tried to implement unplug function in umem, you would find the code was almost identical as in dm/raid driver.
For other components which also need such unplug mechanism, it will much more convenient to have such facilities.
PS: What's your specific concern about blk_plug_cb handles each request_queue?

Thanks,
-Tao

> -----Original Message-----
> From: Shaohua Li [mailto:shlikernel@gmail.com] On Behalf Of Shaohua Li
> Sent: Tuesday, June 05, 2012 9:21 AM
> To: Tao Guo
> Cc: linux-kernel@vger.kernel.org; Guo, Tao; Neil Brown; Jens Axboe;
> stable@vger.kernel.org; Andrew Morton
> Subject: Re: [PATCH 1/2] block: Move general unplug callback function
> from md/raid to blk-core
> 
> On Mon, Jun 04, 2012 at 10:41:50AM -0400, Tao Guo wrote:
> > Other components may also require an unplug callback, so move this
> > function from md/raid to block generic layer.
> 
> I saw no point this should be generic code, for example, why
> blk_plug_cb only
> handles only one request_queue? If umem needs unplug, just do in it.

