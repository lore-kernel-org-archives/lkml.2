Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab2C1Hzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:55:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36717 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2C1Hzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:55:53 -0400
Date: Wed, 28 Mar 2012 11:55:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120328075549.GA2204@moon>
References: <20120326164347.GA24394@redhat.com>
 <20120326183330.GM19395@moon>
 <20120327152534.GA18478@redhat.com>
 <20120327165853.GH11875@moon>
 <20120327222923.GA31692@mail.hallyn.com>
 <20120327223420.GB9669@moon>
 <20120327224640.GA5328@mail.hallyn.com>
 <m162dpo45j.fsf@fess.ebiederm.org>
 <20120328064838.GA2286@moon>
 <m1k425mae1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k425mae1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:51:02AM -0700, Eric W. Biederman wrote:
> > And we could require for a while that F_GETOWNER_UIDS should be called
> > from initial user namespace only. Then we could extend it for being
> > called from any user-namespace if such need appear. Or I miss
> > something?
> 
> Yes.  All that is needed in the short term to do this is a Kconfig
> dependency that limits it a kernel with user namespace support not
> built in something like: "depends !USER_NS"
> 
> Or a check like:
> 	if (current_user_ns() != init_user_ns)
>         	return -EINVAL;
> 
> Basically the mapping would ultimately become:
> uid = from_kuid(current_user_ns(), fown->uid);
> euid = from_kuid(current_user_ns(), fown->euid);
> 
> The different types allow a compile error if you forget the translation.

OK, thanks for the hint!

	Cyrill
