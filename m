Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2JJNWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:22:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54888 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2JJNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:22:53 -0400
Date: Wed, 10 Oct 2012 08:22:27 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: "Wei, Gang" <gang.wei@intel.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "ben@guthro.net" <ben@guthro.net>
Subject: Re: [PATCH] driver/char/tpm: fix regression causesd by ppi
Message-ID: <20121010132227.GB17467@ennui.austin.ibm.com>
References: <1349775322-7896-1-git-send-email-gang.wei@intel.com>
 <20121009221848.GA17467@ennui.austin.ibm.com>
 <D0B11485C64D4B47B66902F8A4E901BE34FF5B@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0B11485C64D4B47B66902F8A4E901BE34FF5B@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101013-7408-0000-0000-00000931AC43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   Hmm, tpm_add_ppi is just sysfs_create_group, which only ever returns
> > 0. Looks like we can remove this error path, but PPI is unusable in the
> > failure case.
> 
> sysfs_create_group will return 0 on success or return error code. So I don't
> think we can remove this error path. The previous call to sysfs_create_group
> also have similar error path.

 Heh, seems "Returns 0 on success or error." doesn't mean what I
thought...

> >> +EXPORT_SYMBOL_GPL(tpm_add_ppi);
> >> ...
> >> +EXPORT_SYMBOL_GPL(tpm_remove_ppi);
> >> 
> >  Do we need to export these symbols?  These might have been left around
> > from when ppi was a standalone module.
> 
> We definitely need to export these symbols, since ppi was in tpm_bios.ko,
> and these symbols are called from tpm.ko.

  Yes, thanks.

Kent

> Jimmy


