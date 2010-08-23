Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0HWQuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0HWQt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:49:58 -0400
Message-ID: <4C72A6B2.4070900@redhat.com>
Date: Mon, 23 Aug 2010 12:49:54 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swhiteho@redhat.com" <swhiteho@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>, "vst@vlnb.net" <vst@vlnb.net>,
        Christoph Hellwig <hch@lst.de>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: [dm-devel] [PATCHSET block#for-2.6.36-post] block: replace barrier
 with sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com> <4C729171.3030605@redhat.com> <20100823164522.GA9528@atlas.home>
In-Reply-To: <20100823164522.GA9528@atlas.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 12:45 PM, Sergey Vlasov wrote:
> On Mon, Aug 23, 2010 at 11:19:13AM -0400, Ric Wheeler wrote:
> [...]
>> (2) hardware raid cards with internal buffer memory and on-card battery backup
>> (they sit in your server, disks sit in jbod like expansion shelves). These are
>> fine if the drives in those shelves have write cache disabled.
>
> Actually some of such cards keep write cache on the drives enabled and
> issue FLUSH CACHE commands to the drives.  E.g., 3ware 9690SA behaves
> like this at least with SATA drives (the FLUSH CACHE commands can be
> seen after enabling performance monitoring - they often end up in the
> "10 commands having the largest latency" table).  This can actually be
> safe if the card waits for the FLUSH CACHE completion before making
> the write cache data in its battery-backed memory available for reuse
> (and the drive implements the FLUSH CACHE command correctly).

Yes - this is certainly one way to do it. Note that this will not work if the 
card advertises itself as a write through cache (and we end up not sending down 
the SYNC_CACHE commands).

At least one hardware RAID card (I unfortunately cannot mention the brand) did 
not do this command forwarding.

ric

