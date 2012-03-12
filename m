Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2CLQyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2CLQyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:54:07 -0400
Date: Mon, 12 Mar 2012 17:53:59 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120312165359.GA32400@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DE6A4.2030303@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 13:05:56 +0100, Denys Vlasenko wrote:
> Build-ids are useful, but they still don't map directly to the names
> of loaded files. You need to rely on /usr/lib/debug/.build-id/XX/YYYYYYYYYY
> symlinks to translate build-ids to names.

There is draft of https://fedoraproject.org/wiki/Darkserver but it is not yet
deployed.  This will give you distro and file version / URL for the specified
build-id.  Without any local symlinks/files at all.

Reasons why it has not yet been finished + deployed I find out of the scope of
this thread.


> Why we don't save library names in coredump?

Because they are useless.  If you have a filename there how to find which
content it should match?  Even if you verify the file is still there with the
same content there is a race it can no longer be true when you read the core
file 5 seconds later.

The build-id mapping server above always works and without races.


> > it can have unknown content etc.
> 
> I don't understand. *What* can have unknown content?

You will save there "/lib64/libc-2.14.90.so".  But the next day you have no
idea which compilation or build the core file was generated for, that virtual
machine can be either already updated or even reinstalled from scratch etc.
"/lib64/libc-2.14.90.so" does not say anything about the build.


> I'll be satisfied with 99.9999% success rate instead of 100% :)

I am not, I prefer 100% build-id server.


Regards,
Jan
