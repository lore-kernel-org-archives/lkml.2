Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032696Ab2CPI7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:59:54 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58853 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202Ab2CPI7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:59:50 -0400
Message-ID: <4F6300BB.9060503@ce.jp.nec.com>
Date: Fri, 16 Mar 2012 17:58:35 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com,
        linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein> <4F3A46DD.8030305@ce.jp.nec.com> <4F5F8D82.2040704@acm.org>
In-Reply-To: <4F5F8D82.2040704@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/14/12 03:10, Bart Van Assche wrote:
> Now that I've had some more time to think about this: has anyone
> considered to hold a reference on the SCSI host instead of the SCSI
> device as long as sd_probe_async() is active ? If sd_prep_fn() can ever
> see a NULL queuedata pointer then that means that
> scsi_host_dev_release() can get invoked while sd_prep_fn() is running.

Holding a host reference does not help, I think.
It does not stop __scsi_remove_device() setting NULL
to sdev's q->queuedata.

So, while there might be another race between sd_probe_async
and scsi_host_remove, I believe your "[PATCH] Fix device
removal NULL pointer dereference" still makes sense.

> That doesn't look correct to me.

-- 
Jun'ichi Nomura, NEC Corporation
