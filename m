Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0GZPkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:40:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab0GZPkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:40:21 -0400
Subject: Re: Filesystem hints to storage
From: James Bottomley <James.Bottomley@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100722204545.7e245988@lxorguk.ukuu.org.uk>
References: <20100722180854.GB22009@parisc-linux.org>
	 <20100722204545.7e245988@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 10:40:15 -0500
Message-ID: <1280158815.6605.175.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 20:45 +0100, Alan Cox wrote:
> > I think there are some hints that are hard for the filesystem to know
> > itself, never mind pass down, so it'd be good to remove them to reduce
> > the complexity.  Contrariwise, there are some hints I think the filesystem
> > could pass down that aren't in the spec today, such as the flags from
> > madvise (random access vs sequential access) and whether the access is
> > for fs metadata or application data.
> 
> Maybe I'm getting cynical with age but I'd put a beer on it being the
> case that implementations ignore the fs provided hints within a few years
> of it becoming regularly used 8)

Actually, you're not cynical ... there was actually a paper at fast two
years ago that showed a deductive algorithm would always outperform a
fixed hint list:

http://www.usenix.org/events/fast09/tech/full_papers/liu/liu_html/index.html

The bottom line is that to perform optimally, there's no agreement
between the client and server for what the hints are; the server just
provides a random set of numbers for hints, which the client uses in an
arbitrary fashion and the server processes the hints in different
classes and tries to work out whether they're useful or not.

The beauty is that because there's no fixed agreement, the client is
free to redefine hints as it sees fit (or fashion changes) and the
server will mostly do the best it can anyway.

James
 

