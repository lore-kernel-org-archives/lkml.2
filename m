Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0ESN4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 09:56:10 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:49966 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab0ESN4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 09:56:08 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
In-Reply-To: <87aarwkzsi.fsf@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl> <87fx1ppy21.fsf@linux.vnet.ibm.com> <20100518064336.GE2150@dastard> <877hn1pl97.fsf@linux.vnet.ibm.com> <9972.1274253351@jrobl> <87d3wsl1dl.fsf@linux.vnet.ibm.com> <87aarwkzsi.fsf@linux.vnet.ibm.com>
Date: Wed, 19 May 2010 22:50:09 +0900
Message-ID: <14013.1274277009@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"Aneesh Kumar K. V":
> How about the below patch ?
>
> commit 5f421ffbe9dd7bb84c5992b1725c06b511bc76d8
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Wed May 19 14:52:44 2010 +0530
>
>     vfs: Return ENOSYS if CONFIG_EXPORTFS is not enabled

Of course, I have no objection. :-)

Let me make sure some other issues.
If a malicious user passes altered dirfd or handle parameters, then
these things may happen.
- opens another file.
  But it should not be a security hole, because finish_open_handle()
  calls may_open() and the permission bits are tested expectedly.
- kernel crashes.
  If s_export_op->fh_to_dentry() expects the passed handle is always
  correct, then it may crash. But this is a problem of FS, instead of
  open_by_handle().
- returns an error.
  It is a matter of the application.
Right?

And the decode routine may return an anonymous (disconnected) dentry.
In this case, if LSM detects something wrong and produces a message,
then the filename will not be printed correctly.
This is not a problem of open_by_handle() either. Right?


J. R. Okajima
