Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2GZCkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 22:40:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2GZCkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 22:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120725155244.GI11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-8-git-send-email-ming.lei@canonical.com>
	<20120725155244.GI11152@aftab.osrc.amd.com>
Date: Thu, 26 Jul 2012 10:40:11 +0800
Message-ID: <CACVXFVM-EZ5VCYqhXEZRC_f=79C5QpJQ5pzVd+quLgadFSqqow@mail.gmail.com>
Subject: Re: [RFC PATCH 07/13] driver core: firmware loader: introduce
 cache_firmware and uncache_firmware
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 11:52 PM, Borislav Petkov <bp@amd64.org> wrote:
>
> You have similar functionality in fw_lookup_and_alloate_buf() above.
> Can't you reuse it instead of defining a new function?

The problem is that the lock can't be released between lookup and allocate
inside fw_lookup_and_alloate_buf(). I will try to introduce __fw_lookup_buf
and reuse it in both fw_lookup_and_alloate_buf and fw_lookup_buf.

Also will fix the comments and code style you mentioned in -v1.


Thanks,
--
Ming Lei
