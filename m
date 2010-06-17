Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab0FQN0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:26:15 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:53118 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759979Ab0FQN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:26:13 -0400
Date: Thu, 17 Jun 2010 09:25:54 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: David Howells <dhowells@redhat.com>, tytso@mit.edu,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Message-ID: <20100617132554.GA8409@elliptictech.com>
Mail-Followup-To: Andy Whitcroft <apw@canonical.com>,
	David Howells <dhowells@redhat.com>, tytso@mit.edu,
	Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@redhat.com>,
	linux-kernel@vger.kernel.org
References: <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
 <20100613194949.GC8055@thunk.org>
 <AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
 <20100614184244.GA11480@elliptictech.com>
 <20100614214646.GF6666@thunk.org>
 <AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com>
 <18402.1276625268@redhat.com>
 <AANLkTilZElLEBJDjfpZVx72uDR-x_3t14Jkga5eHy3wf@mail.gmail.com>
 <20100616143659.GA14616@elliptictech.com>
 <AANLkTikasMn4s1-VgQstblkfP1sy-grJC8NVEUwJ9qKF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikasMn4s1-VgQstblkfP1sy-grJC8NVEUwJ9qKF@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:55 Wed 16 Jun     , Andy Whitcroft wrote:
> On Wed, Jun 16, 2010 at 3:36 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> > The threads sometimes get pegged immediately after booting the system,
> > sometimes it can last an hour or more before showing any problems.
> > Unfortunately, this is making bisection essentially impossible.
> >
> > This seems to have been introduced somewhere between 2.6.35-rc1 and
> 
> I suspect this is introduced by the commit which pulled polling of DRM
> connectors into the core.

OK.  From this hint I looked at the log between -rc1 and -rc2 and found
commit fbf81762e385d ("drm/kms: disable/enable poll around switcheroo
on/off").

Reverting this commit brings everything back to normal.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
