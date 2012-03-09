Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab2CIR3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:29:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab2CIR3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:29:39 -0500
Date: Fri, 9 Mar 2012 18:29:34 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Roland McGrath <mcgrathr@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120309172934.GA18173@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5A3A4D.1020008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denys,

On Fri, 09 Mar 2012 18:13:49 +0100, Denys Vlasenko wrote:
> gdb retrieves loaded library names by examining dynamic loader's
> data stored in the coredump's data segments. It uses intimate
> knowledge how and where dynamic loader keeps the list of loaded
> libraries.

this is the backward compatible way and it is no longer the right one with
build-ids.

GDB should scan the address space for mapped build-ids and map symbol files
accordingly.  The shared library list may be even corrupted in crashes with
memory overruns.  But it has not been implemented yet, I plan it for years.

(It can use the shared library list as a hint as in some cases the symbol
files could overlap if you load the first page of an ELF file etc., this is
very improbable possibility.)


> Another question is detection of deleted files.
> If /usr/lib/xulrunner-2/libmozjs.so was updated while program ran
> and now file mapped into process address space does not correspond
> to the same-named file on disk, can we help users to detect this? How?
> By saving maj/min/inode? Hash thereof?
> File size?
> File's md5sum (probably not, way too expensive. But nicely robust...)?

build-id is already being saved.  This is all that matters.  Filename does not
say anything - as you noticed it can be even already deleted, it can have
unknown content etc.  I do not see what problems you target here.


Regards,
Jan
