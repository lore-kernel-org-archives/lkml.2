Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab2FUVPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:15:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39672 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760312Ab2FUVPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:15:33 -0400
Date: Thu, 21 Jun 2012 22:18:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, Marcel Holtmann <marcel@holtmann.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: make dumpable=2 only write to a pipe
Message-ID: <20120621221858.25b8be67@pyramind.ukuu.org.uk>
In-Reply-To: <20120621194319.GA5961@www.outflux.net>
References: <20120621194319.GA5961@www.outflux.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 12:43:19 -0700
Kees Cook <keescook@chromium.org> wrote:

> When the suid_dumpable sysctl is set to "2", and there is no
> core dump pipe defined in the core_pattern sysctl, a local user
> can cause core files to be written to root-writable directories,
> potentially with user-controlled content. This means an admin
> can unknowningly reintroduce a variation of CVE-2006-2451 (see
> abf75a5033d4da7b8a7e92321d74021d1fcfb502).

Its intended to work the way it does. It's also ABI. I think pipe-only is
a really good idea. Likewise I accept with the pipe feature nowdays there
is a good case to kill off case 2.

However I don't think magically turning one into the other is sensible,
in fact its *stupid* IMHO because it's asking systems to get unexpected
behaviour.

I would much rather see case 2 either left as is, or set to return
-EINVAL (or similar) and a new case 3 for pipe only.

Alan
