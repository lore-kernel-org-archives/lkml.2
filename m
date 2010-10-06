Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab0JFROt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 13:14:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62615 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0JFROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 13:14:48 -0400
Message-ID: <4CACAE56.6090209@vlnb.net>
Date: Wed, 06 Oct 2010 21:13:58 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de,
        James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com,
        jeff@garzik.org
Subject: Re: [RFC v2 00/21] TCM Core and TCM_Loop patches for v2.6.37
References: <1285195702-11421-1-git-send-email-nab@linux-iscsi.org>	 <20101006111621O.fujita.tomonori@lab.ntt.co.jp>	 <1286340405.5685.93.camel@haakon2.linux-iscsi.org>	 <20101006160434M.fujita.tomonori@lab.ntt.co.jp> <1286349898.5685.117.camel@haakon2.linux-iscsi.org> <4CAC833F.2010108@kernel.org>
In-Reply-To: <4CAC833F.2010108@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:fFuXxXO6mOOJjru7Yg8lZDYP7QN9Ui+or1ODkIvHs0y
 jvbWEaiAESrgF8jADLTWqvgcK3qTuj5dDpGvEHSSIG+5E526U5
 TMUaq3KT1sm++0VvQj59311bDALTHpMHBVjcy4jS3i8FiKmLLk
 QLiHN6T8CqvNYvDWQlHoLctUja8qSMYw8R1Xp0Y1c4JhfqMiit
 z8PD2wW5xDCB5GS8yTfyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo, on 10/06/2010 06:10 PM wrote:
> On 10/06/2010 09:24 AM, Nicholas A. Bellinger wrote:
>>> I like to hear the opinions of SCSI maintainer and ATA folks.
>>
>> jejb, jgarzik, tejun and co..?  Any thoughts here..?
> 
> I frankly have no idea whatsoever.  Is there something I can read to
> educate myself on the subject?

General information about a SCSI target subsystem you can find in
http://scst.sourceforge.net. More internal details about implementation
in http://scst.sourceforge.net/scst_pg.html. Features which are
implemented in http://scst.sourceforge.net/comparison.html.

Directly on the subject you can find some considerations in
http://lkml.org/lkml/2010/10/1/140 (second half of the message).

My opinion is that in ideal the SCSI initiator subsystem should be
drivers/scsi/initiator and the target subsystem - drivers/scsi/target
with shared code in drivers/scsi/. But in reality such big
reorganization is unlikely possible, so it's better to leave SCSI
initiator subsystem in drivers/scsi and the target subsystem - in the
separate directory in drivers/ (drivers/scst for SCST).

Vlad
