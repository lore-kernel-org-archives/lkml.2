Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0IBSro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:47:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0IBSrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:47:42 -0400
Message-ID: <4C7FF10B.2040102@vlnb.net>
Date: Thu, 02 Sep 2010 22:46:35 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
References: <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com> <4C7C170D.9090409@vlnb.net> <20100830210205.GD12226@quack.quadriga.com> <4C7CD18B.2060608@panasas.com>
In-Reply-To: <4C7CD18B.2060608@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:YUhYwsVsOo6tanjaH4F0WZ5YZEpIaWibIblq7mDfnV6
 txFgCDE5duX0zOETz+G8qIlIZ9DalAncj+RYIbOKb0Q60yNYj0
 DVmwCrzwW9Q9IkBMEumssFT4W0VBFRUyCJ55Pdq1RaTRZoBU//
 2gLOAp8/iILXao1pFZzPZJdPKcjPNQz4JE5Cu7at9HkrmsF9BH
 HgAPco+1SqNHt4zG4xM8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh, on 08/31/2010 01:55 PM wrote:
>>>>>> An update: I've set up an ext4 barrier testing in KVM - run fsstress,
>>>>>> kill KVM at some random moment and check that the filesystem is consistent
>>>>>> (kvm is run in cache=writeback mode to simulate disk cache). About 70 runs
>>>>>
>>>>> But doesn't your "disk cache" survive the "power cycle" of your guest?
>>>> Yes, you're right. Thinking about it now the test setup was wrong because
>>>> it didn't refuse writes to the VM's data partition after the moment I
>>>> killed KVM. Thanks for catching this. I will probably have to use the fault
>>>> injection on the host to disallow writing the device at a certain moment.
>>>> Or does somebody have a better option?
>>>
>>> Have you considered to setup a second box as an iSCSI target (e.g.
>>> with iSCSI-SCST)? With it killing the connectivity is just a matter
>>> of a single iptables command + a lot more options.
>
> Still same problem no? the data is still cached on the backing store device
> how do you trash the cached data?

If you need to kill the device's cache you can crash/panic/power off the 
target. That also can be well scriptable.

Vlad
