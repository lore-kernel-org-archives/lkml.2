Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1DRJm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:42:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab1DRJmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:42:23 -0400
Message-ID: <4DAC070C.6010403@suse.de>
Date: Mon, 18 Apr 2011 11:40:28 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
Cc: "hch@infradead.org" <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 05/10] block: remove per-queue plugging
References: <20110411205928.13915719@notabene.brown>	<4DA2E03A.2080607@fusionio.com>	<20110411212635.7959de70@notabene.brown>	<4DA2E7F0.9010904@fusionio.com>	<20110411220505.1028816e@notabene.brown>	<4DA2F00E.6010907@fusionio.com>	<20110418081922.1651474a@notabene.brown>	<4DABDC60.2090009@fusionio.com>	<20110418172551.55629fc6@notabene.brown>	<4DABF1EA.3070301@fusionio.com> <20110418091959.GA32013@infradead.org>
In-Reply-To: <20110418091959.GA32013@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 11:19 AM, hch@infradead.org wrote:
> Btw, I really start to wonder if the request level is the right place
> to do this on-stack plugging.  Wouldn't it be better to just plug
> bios in the on-stack queue?  That way we could also stop doing the
> special case merging when adding to the plug list, and leave all the
> merging / I/O schedule logic in the __make_request path.  Probably
> not .39 material, but worth a prototype?
>
> Also what this dicussion brought up is that the block layer data
> structures are highly confusing.  Using a small subset of the
> request_queue also for make_request based driver just doesn't make
> sense.  It seems like we should try to migrate the required state
> to struct gendisk, and submit I/O through a block_device_ops.submit
> method, leaving the request_queue as an internal abstraction for
> the request based drivers.
>
Good point.
It would also help us we the device-mapper redesign agk and myself 
discussed at LSF. Having a block_device_ops.submit function would
allow us remap the actual request queue generically; and we would 
even be able to address more than one request queue, which sounds 
awfully similar to what Jens is trying to do ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
