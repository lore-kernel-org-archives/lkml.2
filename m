Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286Ab2GLW1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:27:47 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54305 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab2GLW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:27:45 -0400
Date: Fri, 13 Jul 2012 00:27:36 +0200 (CEST)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@debianer
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kstrto*: add documentation
In-Reply-To: <20120712221622.GD24162@fieldses.org>
Message-ID: <alpine.DEB.2.02.1207130021280.22180@debianer>
References: <1342126395-18055-1-git-send-email-eldad@fogrefinery.com> <20120712212337.GA24162@fieldses.org> <alpine.DEB.2.02.1207122351580.21938@debianer> <20120712221622.GD24162@fieldses.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Jul 2012, J. Bruce Fields wrote:
> On Fri, Jul 13, 2012 at 12:09:37AM +0200, Eldad Zack wrote:
> > 
> > On Thu, 12 Jul 2012, J. Bruce Fields wrote:
> > I am not sure if I understand _parse_integer correctly (which is called 
> > to do the actual parsing and has a very nice comment to it) - but it 
> > expects a null-terminated string, but will also stop as soon as it 
> > bumps into any other non-number character without error (please correct 
> > me I'm wrong).
> 
> I believe it, but, in _kstrtoull:
> 
> 	rv = _parse_integer(s, base, &_res);
>         if (rv & KSTRTOX_OVERFLOW)
>                 return -ERANGE;
>         rv &= ~KSTRTOX_OVERFLOW;
>         if (rv == 0)
>                 return -EINVAL;
>         s += rv;
>         if (*s == '\n')
>                 s++;
>         if (*s)
>                 return -EINVAL;
> 
> So actually it appears the string must be all numeric except possibly a final
> newline.

Ah. You're right of course. Thanks! I also noticed I missed the SGML 
templates, so I'll resend this at some point later.

Eldad
