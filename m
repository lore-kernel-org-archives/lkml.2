Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1BCWDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:03:53 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:55701 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1BCWDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:03:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19787.9875.652.181110@quad.stoffel.home>
Date: Thu, 3 Feb 2011 17:05:06 -0500
From: "John Stoffel" <john@stoffel.org>
To: "John Stoffel" <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.38-rc3 - make deb-pkg bombs out
In-Reply-To: <19784.18282.668305.184521@quad.stoffel.home>
References: <19784.18282.668305.184521@quad.stoffel.home>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

I've updated this email to include the maintainer and the linux-kbuild
mailing list.

John> I've been trying to do a 'make deb-pkg' on 2.6.38-rc? and not
John> having any luck.  I was going to report this error for -rc2, but
John> saw -rc3 this morning so I grabbed it and tried it out.

John> I can successfully build the kernel on x86_64 (Ubuntu 10.10
John> system, dual core Athlon, 4gb RAM, current directory mounted via
John> NFS), but when I do:

John>   fakeroot make O=/var/tmp/build deb-pkg

Turns out the problem is with the "O=/var/tmp/build" since it works to
build the deb-pkg target in the current directory just fine, using the
same .config and same arguements.  

I guess I'll start to bisect this and see when it last worked.
Looking at the scripts/package/builddeb script, it just needs to be
updated to use the O=/some/path in the find command.  I think.  But I
don't know the build system at all.

Thanks,
John


John> it dies with the following error:

John>       INSTALL include/rdma (1 file)
John>       INSTALL include/scsi/fc (4 files)
John>       INSTALL include/scsi (3 files)
John>       INSTALL include/sound (8 files)
John>       INSTALL include/video (3 files)
John>       INSTALL include/xen (2 files)
John>       INSTALL include (0 file)
John>       INSTALL include/asm (56 files)
John>     find: `arch/x86/include': No such file or directory
John>     make[2]: *** [deb-pkg] Error 1
John>     make[1]: *** [deb-pkg] Error 2
John>     make: *** [sub-make] Error 2

John> Anyone got a hint on what the solution is?

John> John

       
John> -- 
John> --
John> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
John> the body of a message to majordomo@vger.kernel.org
John> More majordomo info at  http://vger.kernel.org/majordomo-info.html
John> Please read the FAQ at  http://www.tux.org/lkml/

-- 
