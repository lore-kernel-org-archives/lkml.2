Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1F1Owj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 10:52:39 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:48776 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab1F1Ovl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 10:51:41 -0400
Message-ID: <4E09EA52.8090006@parrot.com>
Date: Tue, 28 Jun 2011 16:50:58 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: "david.wagner@free-electrons.com" <david.wagner@free-electrons.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>	<1308922482-14967-2-git-send-email-david.wagner@free-electrons.com> <1309202771.24805.11.camel@koala>
In-Reply-To: <1309202771.24805.11.camel@koala>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Artem Bityutskiy a écrit :
> On Fri, 2011-06-24 at 15:34 +0200, david.wagner@free-electrons.com
> wrote:
>> +	/* Stolen from mtd_blkdevs.c */
>> +	/* Create processing thread */
>> +	dev->thread = kthread_run(ubi_ubiblk_thread, dev, "%s%d_%d",
>> +				  "kubiblkd", dev->ubi_num, dev->vol_id);
>> +	if (IS_ERR(dev->thread)) {
>> +		ret = PTR_ERR(dev->thread);
>> +		goto out_thread;
>> +	}
> 
> Why we need a kernel thread? Could you please describe when exactly it
> is needed and why we cannot avoid having it?
Also what are the advantage against gluebi + mtdblock_ro ?
