Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0GaMEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 08:04:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44030 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0GaMEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 08:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bU6pNGDFXFbCgUgNel0qOYLljTFA75K2YboBVvXp8AM5LN4bzGSYu/ihxPPQ+E7l2n
         3O7P+oGFv9vX8AAisfVjjG3ABDHlkO/xvxag2j4wcvrtFlNAqTJGdWhjXrWSvoPUaf1s
         vqF4xooK4fIlfEjDAodSQw9+Dx/ASiZxQUWrI=
Date: Sat, 31 Jul 2010 14:04:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: [070/140] x86: Send a SIGTRAP for user icebp traps
Message-ID: <20100731120451.GA5266@nowhere>
References: <20100730173205.GA22581@kroah.com> <20100730173109.035373791@clark.site> <20100731013919.36c26238@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100731013919.36c26238@katamari>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 01:39:19AM -0400, Chuck Ebbert wrote:
> On Fri, 30 Jul 2010 10:30:35 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > 2.6.33-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > commit a1e80fafc9f0742a1776a0490258cb64912411b0 upstream.
> > 
> 
> This backport will not work. Instead of fixing up the context of this 
> patch to make it apply, commit 40f9249a73f6c251adea492b1c3d19d39e2a9bda 
> ("x86/debug: Clear reserved bits of DR6 in do_debug()") should be 
> applied first, followed by an unmodified version of this commit.


It works because the 2.6.33 backport is slightly different from the 2.6.34 one.
We are dealing with (dr6 & ~0xffff0ff0) rather than dr6.

Backporting the commit you describe seemed too invasive and risky
for me, so I preferred to use that mask to ignore the dr6 reserved bits while
checking the icebp origin, only.

Thanks.

