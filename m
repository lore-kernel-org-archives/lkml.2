Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031247Ab2CNXnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:43:40 -0400
Received: from banjo.employees.org ([198.137.202.19]:26640 "EHLO
	banjo.employees.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965343Ab2CNXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:43:36 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 19:43:36 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=employees.org; h=date:from
	:to:cc:subject:message-id:references:mime-version:content-type
	:in-reply-to; q=dns; s=selector1; b=hKDuTDMIIq94pOLNRJqe/bZFBuV3
	A8AK5qL41wKdX5/uTDNkE/tNeASV1AxFcCODZ1gOC6hG5RTGrW/ukYbtY3ysDaaU
	hYswQHpaytzzuP7avhYwcRjC2y1dkyvXN42eDzw3avLp5XwT5/WXxr8uh9o6SrZW
	4EnN9TtxvI5Dc78=
Date: Wed, 14 Mar 2012 16:33:51 -0700
From: Derek Fawcus <dfawcus+lists-linux-kernel@employees.org>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
Message-ID: <20120314233351.GA17669@banjo.employees.org>
Mail-Followup-To: "H.J. Lu" <hjl.tools@gmail.com>, mingo@redhat.com,
	hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
	linux-tip-commits@vger.kernel.org
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org> <CAMe9rOpGgs9hR31Jxk8ycMNnEoCzUV2_xTeeE+uaEFgz5AEEwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMe9rOpGgs9hR31Jxk8ycMNnEoCzUV2_xTeeE+uaEFgz5AEEwQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:17:29PM -0700, H.J. Lu wrote:
> Just for the record, although the offsets of _utime and _stime are
> multiple of 8 bytes, struct siginfo is only aligned at 4 bytes.  So
> the addresses of  _utime and _stime may not be 8byte aligned.
> But misaligned int64 load/store are OK for x86-64.

So whereas on i386 and x86_64 we can set eflags.AC (or rflags.AC) to test the
code for aligment safeness,  we'll not be able to do so with x32?

(Simply 'cause this could get false positive on syscalls).

Granted this is not a common use,  but I've done it for checking that code
will easily port to ppc/mips.

.pdf
