Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2JBTCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:02:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2JBTC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:02:28 -0400
Message-ID: <506B3A39.9010408@vlnb.net>
Date: Tue, 02 Oct 2012 15:02:17 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] target/file: Re-enable optional fd_buffered_io=1
 operation
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org> <1348984696-30992-2-git-send-email-nab@linux-iscsi.org> <20121001084605.GA23497@infradead.org>
In-Reply-To: <20121001084605.GA23497@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:kNum3rHbN4pdZtfYRi7PCTHVswwI2+OjGS/z4bF2f7a
 f2PPjUMiw2LATt9CDU8cR62cuhocKEXllkTc9xiJQpT6MgUbhP
 ei67aq2eJwApGp4MGW6bOkX5jOFrTwOCoJJubWjxS71Ufbb5Hh
 K1CKOXWz+AvtgEiSIJiqVvtOwutY6f/l3L+dNAUanwaG1oKS4M
 JOkCwP9J9kOnDMlx6/BE/V5IDvN1gScsQvQLq5mzJjvD6a/3lD
 WPWM/BdiBoMFU5k7gdeSZL2U7GMo/iNHzejrKEmkh8RXIWMNpB
 Cbu0GW4Rg7QwqsifcA2G8kPfnTz3EjPpgVqhPckux6JE9jcDwK
 OgDBSdmeWCpjWxFFYzLs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig, on 10/01/2012 04:46 AM wrote:
> On Sun, Sep 30, 2012 at 05:58:11AM +0000, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger<nab@linux-iscsi.org>
>>
>> This patch re-adds the ability to optionally run in buffered FILEIO mode
>> (eg: w/o O_DSYNC) for device backends in order to once again use the
>> Linux buffered cache as a write-back storage mechanism.
>>
>> This difference with this patch is that fd_create_virtdevice() now
>> forces the explicit setting of emulate_write_cache=1 when buffered FILEIO
>> operation has been enabled.
>
> What this lacks is a clear reason why you would enable this inherently
> unsafe mode.  While there is some clear precedence to allow people doing
> stupid thing I'd least like a rationale for it, and it being documented
> as unsafe.

Nowadays nearly all serious applications are transactional, and know how to flush 
storage cache between transactions. That means that write back caching is 
absolutely safe for them. No data can't be lost in any circumstances.

Welcome to the 21 century, Christoph!

Vlad
