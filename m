Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2LTJ6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:58:35 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:12874 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTJ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:58:27 -0500
Message-ID: <50D2E138.7000700@chelsio.com>
Date: Thu, 20 Dec 2012 15:28:16 +0530
From: Vipul Pandya <vipul@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
References: <20121220094433.791d70e55ae5e3325a6190fc@canb.auug.org.au> <CAG4TOxPVc0tNeLhi3FF=K_UJpizh2OZgviT5WqqLvZsg-QEoNw@mail.gmail.com>
In-Reply-To: <CAG4TOxPVc0tNeLhi3FF=K_UJpizh2OZgviT5WqqLvZsg-QEoNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Dec 2012 09:58:21.0083 (UTC) FILETIME=[8AED86B0:01CDDE98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20-12-2012 05:52, Roland Dreier wrote:
> On Wed, Dec 19, 2012 at 2:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the infiniband tree, today's linux-next build (x86_64_
>> allmodconfig) failed like this:
>>
>> In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
>>                  from drivers/scsi/csiostor/csio_scsi.h:49,
>>                  from drivers/scsi/csiostor/csio_init.h:45,
>>                  from drivers/scsi/csiostor/csio_attr.c:45:
>> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: nested redefinition of 'enum fw_retval'
>> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: redeclaration of 'enum fw_retval'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:42:6: note: originally defined here
>> drivers/scsi/csiostor/t4fw_api_stor.h:48:2: error: redeclaration of enumerator 'FW_ENOEXEC'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:39:2: note: previous definition of 'FW_ENOEXEC' was here
>> drivers/scsi/csiostor/t4fw_api_stor.h:50:2: error: redeclaration of enumerator 'FW_ENOMEM'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:43:2: note: previous definition of 'FW_ENOMEM' was here
>> drivers/scsi/csiostor/t4fw_api_stor.h:58:2: error: redeclaration of enumerator 'FW_EADDRINUSE'
>> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:44:2: note: previous definition of 'FW_EADDRINUSE' was here
>>
>> And several others similar.
>>
>> Caused by commit f65b56b15931 ("RDMA/cxgb4: Fix LE hash collision bug for
>> active open connection").
> 
> 
> Vipul, is the right fix to pull the full list of FW return values from
> t4fw_api_stor.h into t4fw_api.h as part of this patch (f65b56b15931)?
> 

Yes, this is a correct way to fix this issue. I see that this change is
already done. Thanks for providing the fix.
