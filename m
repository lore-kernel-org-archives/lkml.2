Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031161Ab2CNXRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:17:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34545 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030752Ab2CNXRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
Date: Wed, 14 Mar 2012 16:17:29 -0700
Message-ID: <CAMe9rOpGgs9hR31Jxk8ycMNnEoCzUV2_xTeeE+uaEFgz5AEEwQ@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hjl.tools@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 2:43 PM, tip-bot for H. Peter Anvin
<hpa@zytor.com> wrote:
> Commit-ID:  31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4
> Gitweb:     http://git.kernel.org/tip/31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Wed, 14 Mar 2012 14:27:52 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Wed, 14 Mar 2012 14:27:52 -0700
>
> x32: Fix alignment fail in struct compat_siginfo
>
> Adding struct _sigchld_x32 caused a misalignment cascade in struct
> siginfo, because union _sifields is located on an 4-byte boundary
> (8-byte misaligned.)
>
> Adding new fields that are 8-byte aligned caused the intermediate
> structures to also be aligned to 8 bytes, thereby adding padding in
> unexpected places.
>
> Thus, change s64 to compat_s64 here, which makes it "misaligned on
> paper".  In reality these fields *are* actually aligned (there are 3
> preceeding ints outside the union and 3 inside struct _sigchld_x32),
> but because of the intervening union and struct it is not possible for
> gcc to avoid padding without breaking the ABI.
>

Just for the record, although the offsets of _utime and _stime are
multiple of 8 bytes, struct siginfo is only aligned at 4 bytes.  So
the addresses of  _utime and _stime may not be 8byte aligned.
But misaligned int64 load/store are OK for x86-64.

-- 
H.J.
