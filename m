Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1DNUuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:50:44 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:52668 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751801Ab1DNUun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:50:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=H60pZ1WsIvFbOuoD9QLw/2LWAaIDD4RIDcrWrlZrtmi0uLYL3G2CvJD1uJWtiI4qUzsPduqubspfqzg7D0e5fzDwFA+zHT0CfF8vzmWF7wMfp9RAr7LAImayuB7BGrfn;
Date: Thu, 14 Apr 2011 13:50:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.37+ for kernel version, what is this + sign?
Message-Id: <20110414135039.9e1ace99.rdunlap@xenotime.net>
In-Reply-To: <BANLkTimnjkV_df2QfirWqjW9g_tkp_pPiA@mail.gmail.com>
References: <BANLkTimnjkV_df2QfirWqjW9g_tkp_pPiA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 09:12:57 -0500 Xianghua Xiao wrote:

> After I disabled LOCALVERSION_AUTO and MODVERSIONS now the kernel
> image is 2.6.37+
> where is the + sign coming from? how can I get rid of it?

It basically means that your git tree is modified.

top-level Makefile calls scripts/setlocalversion, which says (in part):

	# Check for git and a git repo.
	if test -d .git && head=`git rev-parse --verify --short HEAD 2>/dev/null`; then

		# If we are at a tagged commit (like "v2.6.30-rc6"), we ignore
		# it, because this version is defined in the top level Makefile.
		if [ -z "`git describe --exact-match 2>/dev/null`" ]; then

			# If only the short version is requested, don't bother
			# running further git commands
			if $short; then
				echo "+"
				return
			fi


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
