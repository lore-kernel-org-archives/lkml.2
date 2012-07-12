Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab2GLWQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:16:25 -0400
Received: from fieldses.org ([174.143.236.118]:46006 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2GLWQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:16:23 -0400
Date: Thu, 12 Jul 2012 18:16:22 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kstrto*: add documentation
Message-ID: <20120712221622.GD24162@fieldses.org>
References: <1342126395-18055-1-git-send-email-eldad@fogrefinery.com>
 <20120712212337.GA24162@fieldses.org>
 <alpine.DEB.2.02.1207122351580.21938@debianer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207122351580.21938@debianer>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:09:37AM +0200, Eldad Zack wrote:
> 
> On Thu, 12 Jul 2012, J. Bruce Fields wrote:
> > On Thu, Jul 12, 2012 at 10:53:13PM +0200, Eldad Zack wrote:
> > > +/**
> > > + * kstrtoul - convert a string to an unsigned long
> > 
> > Also, is it worth mentioning that the number is required to be followed
> > by a string or newline?
> 
> I am not sure if I understand _parse_integer correctly (which is called 
> to do the actual parsing and has a very nice comment to it) - but it 
> expects a null-terminated string, but will also stop as soon as it 
> bumps into any other non-number character without error (please correct 
> me I'm wrong).

I believe it, but, in _kstrtoull:

	rv = _parse_integer(s, base, &_res);
        if (rv & KSTRTOX_OVERFLOW)
                return -ERANGE;
        rv &= ~KSTRTOX_OVERFLOW;
        if (rv == 0)
                return -EINVAL;
        s += rv;
        if (*s == '\n')
                s++;
        if (*s)
                return -EINVAL;

So actually it appears the string must be all numeric except possibly a final
newline.

--b.
