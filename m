Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1HZRk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:40:59 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:37049 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1HZRk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:40:56 -0400
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Eric Paris <eparis@parisplace.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4E57C93C.3050602@schaufler-ca.com>
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
	 <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com>
	 <4E57C93C.3050602@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Fri, 26 Aug 2011 13:28:43 -0400
Message-ID: <1314379723.25778.26.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 09:26 -0700, Casey Schaufler wrote:
> Is that really how it works? The code reads as if the buffer
> passed by write gets modified in place and the writer is expected
> to use that. There is nothing in the code that looks like the
> response is getting set aside for a subsequent read. If it works
> the way you say it does it will be subject to races up the wazoo.
> If it works the way I think the code says it does it is abusive
> of the write interface.

It is a transaction-based IO, modeled after nfsctl, recommended to us by
viro when we first implemented selinuxfs.  Userspace writes the input
arguments to the file, the kernel computes the result and stores it in a
file-private buffer (hence unique for each open instance, not shared by
multiple openers), and userspace then reads that result back.  Not racy,
not an abuse of write(), and recommended by the vfs maintainer to us.  I
think we're safe on that one.

-- 
Stephen Smalley
National Security Agency

