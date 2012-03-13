Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab2CMWAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:00:05 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57776 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab2CMWAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:00:03 -0400
Date: Tue, 13 Mar 2012 18:00:01 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Frej Eriksson <frej.eriksson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: ext4 extents.c bug
Message-ID: <20120313220000.GC11969@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Frej Eriksson <frej.eriksson@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CACbLGLK8ZLLHzykKb8LRZO+x+_Cqe6r_dna1=QC4nDGSyWrfNw@mail.gmail.com>
 <CACbLGLJTzW-A=oW2hC1URLSCEeVX4RDg--eO=SS3kznXMdB4MQ@mail.gmail.com>
 <20120313195750.GB24124@thunk.org>
 <CACbLGLLLtD8TJd-VvdkQYo48nT5NFE8bmH8aHtwy6-hoCbqL9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACbLGLLLtD8TJd-VvdkQYo48nT5NFE8bmH8aHtwy6-hoCbqL9g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 09:14:18PM +0100, Frej Eriksson wrote:
> 
> Thank you for your the information! If i get you correct does it mean
> that you need to have an updated version of both the kernel and
> e2fsprogs in order to have the issue fixed? Or is it enough to run
> e2fsprogs with the patch applied?

If you run e2fsprogs with the patch applied, it will fix the file
system corruption that caused your kernel to BUG.  If the file system
corruption happens again (for whatever reason; kernel bug, hardware
problem, etc.) then the kernel will BUG instead of printing an
"EXT4-fs error" message and marking the file system as corrupted.

If you have your file system set to "tune2fs -e panic" there will be
no difference (since after the error message the kernel will be forced
to reboot so e2fsck can fix the problem).  But if you have your file
system set to "tune2fs -e continue" or "tune2fs -c read-only", where
you prefer that the file system be mounted read-only or just simply
continue after noting a file system corruption problem, and you want
that behavior, then you'd have to apply the kernel patch as well.
(You can see what the corrent behaviour on file systems errors by
looking at the output of "dumpe2fs -h /dev/sdXX | grep ^Errors".)

Regards,

						- Ted
