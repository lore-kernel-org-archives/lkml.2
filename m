Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2LTAro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:47:44 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39156 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2LTArh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:47:37 -0500
X-Greylist: delayed 1462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 19:47:37 EST
MIME-Version: 1.0
In-Reply-To: <20121220094433.791d70e55ae5e3325a6190fc@canb.auug.org.au>
References: <20121220094433.791d70e55ae5e3325a6190fc@canb.auug.org.au>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 19 Dec 2012 16:22:54 -0800
X-Google-Sender-Auth: iLZ-dQmZ8dJMllr57Zo9iIRwHbw
Message-ID: <CAG4TOxPVc0tNeLhi3FF=K_UJpizh2OZgviT5WqqLvZsg-QEoNw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipul Pandya <vipul@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 2:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the infiniband tree, today's linux-next build (x86_64_
> allmodconfig) failed like this:
>
> In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
>                  from drivers/scsi/csiostor/csio_scsi.h:49,
>                  from drivers/scsi/csiostor/csio_init.h:45,
>                  from drivers/scsi/csiostor/csio_attr.c:45:
> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: nested redefinition of 'enum fw_retval'
> drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: redeclaration of 'enum fw_retval'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:42:6: note: originally defined here
> drivers/scsi/csiostor/t4fw_api_stor.h:48:2: error: redeclaration of enumerator 'FW_ENOEXEC'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:39:2: note: previous definition of 'FW_ENOEXEC' was here
> drivers/scsi/csiostor/t4fw_api_stor.h:50:2: error: redeclaration of enumerator 'FW_ENOMEM'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:43:2: note: previous definition of 'FW_ENOMEM' was here
> drivers/scsi/csiostor/t4fw_api_stor.h:58:2: error: redeclaration of enumerator 'FW_EADDRINUSE'
> drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:44:2: note: previous definition of 'FW_EADDRINUSE' was here
>
> And several others similar.
>
> Caused by commit f65b56b15931 ("RDMA/cxgb4: Fix LE hash collision bug for
> active open connection").


Vipul, is the right fix to pull the full list of FW return values from
t4fw_api_stor.h into t4fw_api.h as part of this patch (f65b56b15931)?
