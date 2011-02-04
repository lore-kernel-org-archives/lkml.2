Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1BDGbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 01:31:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab1BDGba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 01:31:30 -0500
Message-ID: <4D4B9CE3.7080505@redhat.com>
Date: Fri, 04 Feb 2011 14:29:55 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
References: <1296442381-21652-1-git-send-email-amwang@redhat.com> <20110201173738.GA18526@infradead.org>
In-Reply-To: <20110201173738.GA18526@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年02月02日 01:37, Christoph Hellwig 写道:
> On Mon, Jan 31, 2011 at 10:53:00AM +0800, Amerigo Wang wrote:
>> Our kdump script needs /sys/block/X/device/{vendor, model, type},
>> but virtio devices don't have {model, type}, this patch adds them.
>> Actually, I don't know how to fill the model field, other block devices
>> seem read it from SCSI. Any comments?
>
> It does not make any sense to fill this at all in virtio.  The
> attributes are simply exporting the SCSI INQUIRY data, and do not make
> any sense at all outside a SCSI context.  In fact the type field even
> contains numbers from the scsi protocol spec that just don't make sense.
>

Hmm, so other non-SCSI devices don't have these neither?
Do you have any suggestions to find another way to identify a disk?

Thanks.
