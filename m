Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1DKMss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:48:48 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:49181 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab1DKMsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:48:47 -0400
X-ASG-Debug-ID: 1302526126-03d6a55d3887780001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA2F8AD.1060605@fusionio.com>
Date: Mon, 11 Apr 2011 14:48:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<4D761E0D.8050200@fusionio.com>	<20110308202100.GA31744@redhat.com>	<4D76912C.9040705@fusionio.com>	<20110308220526.GA393@redhat.com>	<20110310005810.GA17911@redhat.com>	<20110405130541.6c2b5f86@notabene.brown>	<20110411145022.710c30e9@notabene.brown>	<4DA2C7BE.6060804@fusionio.com>	<20110411205928.13915719@notabene.brown>	<4DA2E03A.2080607@fusionio.com>	<20110411212635.7959de70@notabene.brown>	<4DA2E7F0.9010904@fusionio.com>	<20110411220505.1028816e@notabene.brown>	<4DA2F00E.6010907@fusionio.com> <20110411223623.4278fad1@notabene.brown>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110411223623.4278fad1@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302526126
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60542
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-11 14:36, NeilBrown wrote:
> On Mon, 11 Apr 2011 14:11:58 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>>> Yes.  But I need to know when to release the requests that I have stored.
>>> I need to know when ->write_pages or ->read_pages or whatever has finished
>>> submitting a pile of pages so that I can start processing the request that I
>>> have put aside.  So I need a callback from blk_finish_plug.
>>
>> OK fair enough, I'll add your callback patch.
>>
> 
> Thanks.  I'll queue up my md fixes to follow it once it gets  to -linus.

Great, once you do that and XFS kills the blk_flush_plug() calls too,
then we can remove that export and make it internal only.

-- 
Jens Axboe

