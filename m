Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0H3VDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:03:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0H3VC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:02:58 -0400
Date: Mon, 30 Aug 2010 23:02:05 +0200
From: Jan Kara <jack@suse.cz>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
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
Message-ID: <20100830210205.GD12226@quack.quadriga.com>
References: <1282751267-3530-27-git-send-email-tj@kernel.org>
 <20100825155842.GA3229@lst.de>
 <20100825160032.GC3229@lst.de>
 <4C753D75.2010305@kernel.org>
 <20100825200223.GE2738@quack.suse.cz>
 <4C76250B.6060800@kernel.org>
 <20100827173147.GA12374@quack.suse.cz>
 <x4939tv98n8.fsf@segfault.boston.devel.redhat.com>
 <20100830202034.GB12226@quack.quadriga.com>
 <4C7C170D.9090409@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7C170D.9090409@vlnb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 31-08-10 00:39:41, Vladislav Bolkhovitin wrote:
> Jan Kara, on 08/31/2010 12:20 AM wrote:
> >On Mon 30-08-10 15:56:43, Jeff Moyer wrote:
> >>Jan Kara<jack@suse.cz>  writes:
> >>
> >>>   An update: I've set up an ext4 barrier testing in KVM - run fsstress,
> >>>kill KVM at some random moment and check that the filesystem is consistent
> >>>(kvm is run in cache=writeback mode to simulate disk cache). About 70 runs
> >>
> >>But doesn't your "disk cache" survive the "power cycle" of your guest?
> >   Yes, you're right. Thinking about it now the test setup was wrong because
> >it didn't refuse writes to the VM's data partition after the moment I
> >killed KVM. Thanks for catching this. I will probably have to use the fault
> >injection on the host to disallow writing the device at a certain moment.
> >Or does somebody have a better option?
> 
> Have you considered to setup a second box as an iSCSI target (e.g.
> with iSCSI-SCST)? With it killing the connectivity is just a matter
> of a single iptables command + a lot more options.
  Hmm, this might be an interesting option. Will try that. Thanks for
suggestion. 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
