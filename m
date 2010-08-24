Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0HXRMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:12:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab0HXRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:12:12 -0400
Message-ID: <4C73FD52.7000305@vlnb.net>
Date: Tue, 24 Aug 2010 21:11:46 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Christoph Hellwig <hch@lst.de>,
        jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org> <20100817131915.GB2963@lst.de> <4C6ABBCB.9030306@kernel.org> <20100817165929.GB13800@lst.de> <4C6E3C1A.50205@ct.jp.nec.com> <4C72660A.7070009@kernel.org>
In-Reply-To: <4C72660A.7070009@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:UpqIwEFWe7clA0iPB3B/SneA2aqM33/HVpjEb0eCmm6
 98kriCXUt2haDXqbstArKYNSpGHSRFzhJDklGfQE0roCpTc8At
 6NelDi8Fyxbnks3dMHQs4vmFU2cbD8yw3g8sgQeEndECQitOdO
 CSCRqTC+CWg3GMQYLFx2LvmpWrrHO8uJ5vfkWp33WU4+qZmu9R
 pwWww7/gdVhVF1jWOHonA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo, on 08/23/2010 04:14 PM wrote:
>> I think that's correct and changing the priority of DM_ENDIO_REQUEUE
>> for REQ_FLUSH down to the lowest should be fine.
>> (I didn't know that FLUSH failure implies data loss possibility.)
>
> At least on ATA, FLUSH failure implies that data is already lost, so
> the error can't be ignored or retried.

In SCSI there are conditions when a command, including FLUSH 
(SYNC_CACHE), failed which don't imply lost data. For them the caller 
expected to retry the failed command. Most common cases are Unit 
Attentions and TASK QUEUE FULL status.

Vlad
