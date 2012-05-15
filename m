Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab2EOVnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:43:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48976 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab2EOVnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <1337112446.20904.50.camel@falcor>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com> <1337112446.20904.50.camel@falcor>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 May 2012 14:43:15 -0700
X-Google-Sender-Auth: 2BFaFkx1pKqv9JRBRsFwFeX6zb0
Message-ID: <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 1:07 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> If the security_file_mmap() moves to before taking the mmap_sem and the
> new security_mmap_addr() hook would be at the current
> security_file_mmap() location, I don't see the problem.  The addr test
> would remain in the same place.

Btw, please do change the name at the same time, so that the new
"file" testing function is "security_mmap_file()". That way a grep
shows any stale cases, rather than having to look at the exact
arguments (it does lose the last argument too).

                   Linus
