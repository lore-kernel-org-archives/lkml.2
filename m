Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1LHS1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:27:02 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34360 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166Ab1LHS1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:27:01 -0500
X-Sasl-enc: 7OaFFpj6j61GLUiYYXs6bm57bC5GZ+jDAW10wgS23mpw 1323368820
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: John Stoffel <john@stoffel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 08 Dec 2011 13:26:40 -0500
In-Reply-To: <20192.65168.140290.462594@quad.stoffel.home>
References: <1323280461.10724.13.camel@lenny>
	 <20191.49202.793643.397028@quad.stoffel.home>
	 <1323360655.10724.35.camel@lenny>
	 <20192.65168.140290.462594@quad.stoffel.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323368800.10724.73.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 13:14 -0500, John Stoffel wrote:

> Or is it because you're trying to edit on one OS, such a fedora 14,
> then build and debug inside an Debian 5.0 setup?  But without running
> a completely seperate system, but just doing a chroot into a new
> filesystem tree?  

Yes, something like that; basically it's about ensuring that the libfoo
we're building binaries against is /home/walters/build/libfoo.so and
not /usr/lib/libfoo.so.

I'm actually intending for the core build system of my OS to work in
*both* cross and native compilation.  That means it's important to keep
them as close as possible.

What you were talking about above (i.e. "just don't chroot") is what
http://buildroot.net does (and others, I also semi-maintain GNOME's
jhbuild).  It works if you're very careful in your build scripts, know
and carefully propagate the large set of magic environment variables,
etc., then yes, you can do it.

But chroot is just so nice a hammer for this nail.



