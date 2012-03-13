Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2CMT5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:57:53 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57751 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab2CMT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:57:52 -0400
Date: Tue, 13 Mar 2012 15:57:50 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Frej Eriksson <frej.eriksson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fwd: ext4 extents.c bug
Message-ID: <20120313195750.GB24124@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Frej Eriksson <frej.eriksson@gmail.com>,
	linux-kernel@vger.kernel.org
References: <CACbLGLK8ZLLHzykKb8LRZO+x+_Cqe6r_dna1=QC4nDGSyWrfNw@mail.gmail.com>
 <CACbLGLJTzW-A=oW2hC1URLSCEeVX4RDg--eO=SS3kznXMdB4MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACbLGLJTzW-A=oW2hC1URLSCEeVX4RDg--eO=SS3kznXMdB4MQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 08:39:56PM +0100, Frej Eriksson wrote:
> [  950.128885] ------------[ cut here ]------------
> [  950.128893] kernel BUG at /build/buildd/linux-2.6.35/fs/ext4/extents.c:1971!

Your file system is corrupted, and there are two bugs.  (1) e2fsck
wasn't detecting this form of file system corruption (a zero-length
extent entry), and (2) the kernel was not noticing until an assertion
check using BUG_ON, instead of flagging this as a file systme error.

The fixes for both of these problems, in the kernel and in e2fsprogs,
are here:

    http://article.gmane.org/gmane.comp.file-systems.ext4/31359
    http://article.gmane.org/gmane.comp.file-systems.ext4/31360

Best regards,

						- Ted
