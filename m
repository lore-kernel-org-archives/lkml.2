Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1LLV6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:58:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53264 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042Ab1LLV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:58:34 -0500
Date: Mon, 12 Dec 2011 21:58:18 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <20111212215818.GP3366@decadent.org.uk>
References: <1319461948.31243.31.camel@deadeye>
 <CAB=NE6Vt91tHCBj7sJHjUCaDZZPqox+omcQjsEj54vQAtbY2bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=NE6Vt91tHCBj7sJHjUCaDZZPqox+omcQjsEj54vQAtbY2bw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 01:40:44PM -0800, Luis R. Rodriguez wrote:
> On Mon, Oct 24, 2011 at 6:12 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> > Use of the GPL or a compatible licence doesn't necessarily make the code
> > any good.  We already consider staging modules to be suspect, and this
> > should also be true for out-of-tree modules which may receive very
> > little review.
> >
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > Debian has been carrying this for the last few kernel versions.  The
> > recent thread '[RFC] virtualbox tainting.' and discussions at KS suggest
> > that this might be more generally useful.
> 
> This indeed seems like a good idea to advocate getting things upstream
> (not just staging) but what about the case where we have upstream
> drivers from future kernels backported to older kernels and the newer
> driver is simply provided as a feature for users who may need new
> features / chipset support on their old distribution kernel?

They continue to work without any loss of functionality.  (After the
follow-up patches to keep dynamic debugging and lock debugging
working.)

> It seems this taint flag will be used for driers backported through
> compat-wireless, the compat kernel module or any other backported
> driver, even if it is indeed upstream and whereby kernel developer
> *do* commit to actually fixing issues. In our experience
> compat-wireless bugs *are real bugs*, not backport bugs so we do look
> into them. In our latest linux-next.git based release for example
> backport code consists only of 1.3804% of the code.

Now you can look for (O) after the module name in a BUG/Oops message
and you can tell whether the user really had the original or
compat-wireless version of the driver.

It is really up to each distributor or developer how they treat
bug reports with the O taint.  When handling Debian bug reports I
won't automatically reject such a tainted kernel but I will look
carefully at the module list.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
