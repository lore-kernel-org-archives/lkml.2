Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2G0KQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:16:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2G0KQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:16:08 -0400
Message-ID: <50126A64.9040206@suse.de>
Date: Fri, 27 Jul 2012 12:16:04 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>  <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>  <50044D56.6000400@redhat.com>  <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>  <50052390.7030908@redhat.com>  <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>  <5005285E.8060706@redhat.com>  <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>  <20120717163612.GA15995@infradead.org> <1342562390.3039.100.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342562390.3039.100.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 11:59 PM, James Bottomley wrote:
> On Tue, 2012-07-17 at 12:36 -0400, Christoph Hellwig wrote:
>> On Tue, Jul 17, 2012 at 10:11:57AM +0100, James Bottomley wrote:
>>> There's no such thing in the market today as a removable disk that's
>>> resizeable.  Removable disks are for things like backup cartridges and
>>> ageing jazz drives.  Worse: most removeable devices today are USB card
>>> readers whose standards compliance varies from iffy to non existent.
>>> Resizeable disks are currently the province of storage arrays.
>>
>> The virtual disks exported by aacraid are both marked removable and
>> can be resized.
> 
> So what are properties of these things? ... or is this just an instance
> of a RAID manufacturer hacking around a problem by adding a removable
> flag?
> 
Presumably.

The general intention is to automatically catch any disk resizing.
As the SCSI stack (used to) ignore these things that was their way
of working around it.

Curiously, though; the aacraid driver is the only one doing this,
plus the process is quite involved (using a proprietary application
for doing so etc).

None of the FC driver do this, despite the fact that resizing a disk
is even easier here.

I even tried to remove that line once, but then got told off by then
Adaptec that I would break their apps.
Since then there's a patch in the SLES kernel for adding a module
option switching off this behaviour.

We should ask Adaptec/PMC-Sierra here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)


