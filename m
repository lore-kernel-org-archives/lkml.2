Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0LQJnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 04:43:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:50478 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab0LQJnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 04:43:11 -0500
Message-ID: <4D0B31B5.101@suse.de>
Date: Fri, 17 Dec 2010 10:47:33 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu,
        tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        vst@vlnb.net, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org,
        linux-ide@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        James.Bottomley@suse.de, Sergei Shtylyov <sshtylyov@mvista.com>,
        konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
        jack@suse.cz, rwheeler@redhat.com, swhiteho@redhat.com,
        chris.mason@oracle.com, Tejun Heo <tj@kernel.org>
Subject: Re: training mpath to discern between SCSI errors
References: <20100825155918.GB8509@redhat.com> <4C7B984E.4070802@suse.de> <4C7B9F14.9080900@mvista.com> <4C7BA670.2060303@suse.de> <4C7BC5B4.3010707@suse.de> <4CBC00B3.7090603@ce.jp.nec.com> <4CBC35AE.9050002@suse.de> <20101119031149.GA28455@us.ibm.com> <20101130225956.GA8882@redhat.com>
In-Reply-To: <20101130225956.GA8882@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 11:59 PM, Mike Snitzer wrote:
> On Thu, Nov 18 2010 at 10:11pm -0500,
> Malahal Naineni <malahal@us.ibm.com> wrote:
> 
>> Hannes Reinecke [hare@suse.de] wrote:
>>>> Also (although this might be a bit off topic from your patch),
>>>> can we expand such a distinction to what should be logged?
>>>> Currently, it's difficult to distinguish important SCSI/block errors
>>>> and less important ones in kernel log.
>>>> For example, when I get a link failure on sda, kernel prints something
>>>> like below, regardless of whether the I/O is recovered by multipathing or not:
>>>>   end_request: I/O error, dev sda, sector XXXXX
>>>>
>>> Indeed, when using the above we could be modifying the above
>>> message, eg by
>>>
>>> end_request: transport error, dev sda, sector XXXXX
>>>
>>> or
>>>
>>> end_request: target error, dev sda, sector XXXXX
>>>
>>> which would improve the output noticeable.
>>>
>>>> Setting REQ_QUIET in dm-multipath could mask the message
>>>> but also other important ones in SCSI.
>>>>
>>> Hmm. Not sure about that, but I think the above modifications will
>>> be useful already.
>>>
>>> I'll be sending an updated patch.
>>
>> Hannes, is there an updated version of this patch? It applied fine with
>> Linus git tree with a minor reject! I would like to test an updated
>> version if you have one (the update seems to refer to better logging
>> only, right?).
> 
> Hannes,
> 
> Any chance you've had time to fold your proposed logging changes in and
> rebase this patch?  Could you post that updated patch?
> 
yes, will be following shortly.

> I'd like to help see this patch through to inclussion when 2.6.38 merge
> window opens.  I can help with further review, testing and development.
> 
Ok, thanks.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
