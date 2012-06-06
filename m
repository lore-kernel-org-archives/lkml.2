Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2FFCHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 22:07:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38959 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2FFCHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 22:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <5723ED3022C1484092D8E8139108116905581F3ACF@MX18A.corp.emc.com>
References: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
	<20120605012116.GA357@kernel.org>
	<5723ED3022C1484092D8E8139108116905581F3ACF@MX18A.corp.emc.com>
Date: Wed, 6 Jun 2012 10:07:07 +0800
X-Google-Sender-Auth: UtKkfVPmOeIShdfbdvDfaTuMAcw
Message-ID: <CANejiEVyUiatJ4pKHS9n3skf4uOHh7wKLibQA9e_HK8UFZYmMQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: Move general unplug callback function from
 md/raid to blk-core
From: Shaohua Li <shli@kernel.org>
To: Tao.Guo@emc.com
Cc: glorioustao@gmail.com, linux-kernel@vger.kernel.org, neilb@suse.de,
        axboe@kernel.dk, stable@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/5  <Tao.Guo@emc.com>:
> If you ever tried to implement unplug function in umem, you would find the code was almost identical as in dm/raid driver.
> For other components which also need such unplug mechanism, it will much more convenient to have such facilities.
It's just several lines of code and your usage actually doesn't need
the counter.
It's unclear to me your usage requires to move the callback to list head.

> PS: What's your specific concern about blk_plug_cb handles each request_queue?
the blk_plug_cb stores request_queue, which is incorrect to me. Why can't
one plug cb unplug two or more request_queues?
