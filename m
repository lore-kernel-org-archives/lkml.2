Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab0HXXjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:39:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36043 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755753Ab0HXW6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:22 -0400
Date: Wed, 25 Aug 2010 00:14:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Tejun Heo <tj@kernel.org>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz,
        rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Message-ID: <20100825001421.67eb8aad@lxorguk.ukuu.org.uk>
In-Reply-To: <4C73FD52.7000305@vlnb.net>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
	<20100813114858.GA31937@lst.de>
	<4C654D4B.1030507@kernel.org>
	<20100813143820.GA7931@lst.de>
	<4C655BE5.4070809@kernel.org>
	<20100814103654.GA13292@lst.de>
	<4C6A5D8A.4010205@kernel.org>
	<20100817131915.GB2963@lst.de>
	<4C6ABBCB.9030306@kernel.org>
	<20100817165929.GB13800@lst.de>
	<4C6E3C1A.50205@ct.jp.nec.com>
	<4C72660A.7070009@kernel.org>
	<4C73FD52.7000305@vlnb.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In SCSI there are conditions when a command, including FLUSH 
> (SYNC_CACHE), failed which don't imply lost data. For them the caller 
> expected to retry the failed command. Most common cases are Unit 
> Attentions and TASK QUEUE FULL status.

ATA expects the command to be retried as well because a failed flush
indicates the specific sector is lost (unless the host still has a copy
of course - which is *very* likely although we don't use it) but the rest
of the flush transaction can be retried to continue to flush sectors
beyond the failed one.

Alan
