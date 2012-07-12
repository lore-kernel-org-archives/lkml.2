Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab2GLWJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:09:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60191 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2GLWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:09:50 -0400
Date: Fri, 13 Jul 2012 00:09:37 +0200 (CEST)
From: Eldad Zack <eldad@fogrefinery.com>
X-X-Sender: eldad@debianer
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kstrto*: add documentation
In-Reply-To: <20120712212337.GA24162@fieldses.org>
Message-ID: <alpine.DEB.2.02.1207122351580.21938@debianer>
References: <1342126395-18055-1-git-send-email-eldad@fogrefinery.com> <20120712212337.GA24162@fieldses.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Jul 2012, J. Bruce Fields wrote:
> On Thu, Jul 12, 2012 at 10:53:13PM +0200, Eldad Zack wrote:
> > +/**
> > + * kstrtoul - convert a string to an unsigned long
> 
> Also, is it worth mentioning that the number is required to be followed
> by a string or newline?

I am not sure if I understand _parse_integer correctly (which is called 
to do the actual parsing and has a very nice comment to it) - but it 
expects a null-terminated string, but will also stop as soon as it 
bumps into any other non-number character without error (please correct 
me I'm wrong).
In that case maybe "This function stops parsing as soon as it gets to a 
character which doesn't belong to the given base, including newline 
or null.".

And now that I read it more closely, how about:
"If base is given as 0, then the base of the string is automatically
detected with the conventional semantics: If the string begins with 0x
the number will be parsed as a hexadecimel (case insensitive). If
it otherwise begins with 0, it will be parsed as an octal number.
Otherwise it will be parsed as a decimal."

Eldad

