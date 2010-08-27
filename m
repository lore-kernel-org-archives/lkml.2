Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0H0RnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:43:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab0H0RnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:43:17 -0400
Date: Fri, 27 Aug 2010 13:43:13 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Karel Zak <kzak@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to change_mnt_propagation()
Message-ID: <20100827174313.GA26872@shell>
References: <20100826200318.GA13636@shell> <20100827011436.GB3521@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827011436.GB3521@parisc-linux.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 07:14:36PM -0600, Matthew Wilcox wrote:
> On Thu, Aug 26, 2010 at 04:03:18PM -0400, Valerie Aurora wrote:
> > +	/* Fail if any non-propagation flags are set */
> > +	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
> > +		return 0;
> > +	/* Only one propagation flag should be set */
> > +	if (((type & (MS_SHARED)) && (type & ~MS_SHARED)) ||
> > +	    ((type & (MS_PRIVATE)) && (type & ~MS_PRIVATE)) ||
> > +	    ((type & (MS_SLAVE)) && (type & ~MS_SLAVE)) ||
> > +	    ((type & (MS_UNBINDABLE)) && (type & ~MS_UNBINDABLE)))
> > +		return 0;
> 
> Hrm.  I think we can do this a bit more pithily.
> 
> 	/* Only one propagation flag should be set, and no others */
> 	if (hweight32(type) != 1 &&
> 	    (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
> 		return 0;
> 
> Too clever?

I was hoping someone would go find the best bitop for me, thanks. :)
hweight32() is an awkward name but the comment makes it clear.  I'm
happy with either.

Thanks for the help,

-VAL
