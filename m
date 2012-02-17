Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2BQTmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:42:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34075 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2BQTmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:42:12 -0500
Date: Fri, 17 Feb 2012 23:37:19 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>,
        pageexec@freemail.hu, spender@grsecurity.net
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Message-ID: <20120217193719.GA4187@albatros>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros>
 <20120217175445.GC29902@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217175445.GC29902@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 09:54 -0800, Greg KH wrote:
> I'm referring to the fact that the use of kref in this type of error or
> problem is rare.
> 
> Yes, we have these types of problems at times, but a kref doesn't seem
> to be involved in them that I know of, so changing the kref code
> wouldn't help here from what I can tell.

Ehr, what's the difference between kref and "raw" atomic_t in a refcounting case?
There is _no_ difference in sense of overflows as a kref uses the same atomic_t.

I second David that we should use kref for overflow protection: we want to
hook an overflow case somehow in cases atomic_t is used as a refcounter.  It is
_ideally_ handled by introducing atomic_t's subtype.  And this subtype already
exists - it is called kref.


I expect all atomic_t refcounters users have

	if (atomic_dec_and_test()) smth_put() 

pattern, otherwise it is not a true refcounter :)  It should be straightforward to
move to kref.


Moving to atomic64_t is attractive, but:

1) we still should find all atomic_t refcounters.  Why not move to kref then?

2) what to do with architectures-loosers?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
