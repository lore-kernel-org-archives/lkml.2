Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2CVUKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:10:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55043 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2CVUKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:10:30 -0400
Date: Thu, 22 Mar 2012 20:10:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@parisplace.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Regression introduced by
 bfcfaa77bdf0f775263e906015982a608df01c76 (vfs: use 'unsigned long' accesses
 for dcache name comparison and hashing)
Message-ID: <20120322201027.GA6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com>
 <CACLa4pt0iQDM14N8AwqBmuZESYaevy6Km8CF_0pEeP+ydH7xjw@mail.gmail.com>
 <CACLa4psVGvymuLGJTV+e=n3mYY2h4=nBhb6FGD_PjjE=xMtZgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLa4psVGvymuLGJTV+e=n3mYY2h4=nBhb6FGD_PjjE=xMtZgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 04:03:45PM -0400, Eric Paris wrote:
> Reverting this patch also fixed the spurious ENOENT problems (and
> related boot failures) from SELinux.
> 
> Easy reproducer with SELinux enabled (although might I suggest
> permissive/enforcing=0 since the box can't boot otherwise):
> 
> compute_create system_u:system_r:kernel_t:s0
> system_u:object_r:init_exec_t:s0 process
> 
> If you get back system_u:object_r:init_exec_t:s0 it failed and you'll
> see under strace the ENOENT stat() failure.
> 
> If you get back system_u:object_r:init_t:s0 it means it worked...

Unless I'm misreading that code, the problem should hit on names with
length being a multiple of 8...
