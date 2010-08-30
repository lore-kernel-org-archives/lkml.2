Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0H3MjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:39:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0H3MjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:39:17 -0400
Message-ID: <4C7BA670.2060303@suse.de>
Date: Mon, 30 Aug 2010 14:39:12 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Tejun Heo <tj@kernel.org>, michaelc@cs.wisc.edu,
        James.Bottomley@suse.de, tytso@mit.edu, linux-scsi@vger.kernel.org,
        jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        swhiteho@redhat.com, linux-raid@vger.kernel.org,
        linux-ide@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp,
        linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com,
        Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com,
        dm-devel@redhat.com
Subject: Re: [RFC] training mpath to discern between SCSI errors
References: <20100825155918.GB8509@redhat.com> <4C7B984E.4070802@suse.de> <4C7B9F14.9080900@mvista.com>
In-Reply-To: <4C7B9F14.9080900@mvista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
> 
> Hannes Reinecke wrote:
> 
>> Actually, I think we have two separate issues here:
>> 1) The need of having more detailed I/O errors even in the fs layer. This
>>    we've already discussed at the LSF, consensus here is to allow other
>>    errors than just 'EIO'.
>>    Instead of Mike's approach I would rather use existing error codes
>> here;
>>    this will make the transition somewhat easier.
>>    Initially I would propose to return 'ENOLINK' for a transport failure,
>>    'EIO' for a non-retryable failure on the target, and 'ENODEV' for a
>>    retryable failure on the target.
> 
>    Are you sure it's not vice versa: EIO for retryable and ENODEV for
> non-retryable failures. ENODEV looks more like permanent condition to me.
> 
Ok, can do.
And looking a the error numbers again, maybe we should be using 'EREMOTEIO'
for non-retryable failures.

So we would be ending with:

ENOLINK: transport failure
EIO: retryable remote failure
EREMOTEIO: non-retryable remote failure

Does that look okay?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
