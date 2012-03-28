Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2C1Ov5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:51:57 -0400
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:36555 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2C1Ovz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:51:55 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: copy-up xattr (Re: [RFC][PATCH 00/73] Union Mount [ver #2])
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com, linux-kernel@vger.kernel.org,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov
In-Reply-To: <9343.1332771770@redhat.com>
References: <18418.1330238913@jrobl> <20120221175721.25235.8901.stgit@warthog.procyon.org.uk> <9343.1332771770@redhat.com>
Date: Wed, 28 Mar 2012 23:51:52 +0900
Message-ID: <7309.1332946312@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells:
> That's not necessarily good enough.  What if and LSM, say SELinux, is in
> force?  Now SELinux will happily label the files for you - but there's a
> reasonable chance they won't be correct.  OTOH, they may not be correct even
> if they are copied up.

Then what will happen (or should happen) in cp(1) for such cases?
Can the --preserve=context or xattr option handle it correctly?
If cp(1) can hanle it correctly, then union-mount may be able to behave
similarly, or make the internal copy-up operaion a totally isolated
userspace module.
If cp(1) cannot, then union-mount will not either. And union-mount
should delete the copied-up file after the xattr error, while cp(1) may
left the copied file.

Finally, the number of cases which copy-up xattr succeeds may not be so
many, and the situation is similar to cp(1) which copies a file between
different filesystems.


J. R. Okajima
