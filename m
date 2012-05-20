Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2ETNHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 09:07:48 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:34080 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2ETNHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 09:07:47 -0400
Date: Sun, 20 May 2012 13:10:12 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] Trace event for capable().
Message-ID: <20120520131012.GA1100@mail.hallyn.com>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
 <CAFLxGvzZ_YJS25wK=YHCELwJOZZuhdeoB6S5Yw_TMVEXzTofOg@mail.gmail.com>
 <CABsxX9JWK1qVubuYt0+HoZy-Lhz0kp6a3MxyT7ny5YzLS2rMJQ@mail.gmail.com>
 <1337383163.1463.2.camel@Nokia-N900-51-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337383163.1463.2.camel@Nokia-N900-51-1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge Hallyn (serge@hallyn.com):
> 
> ----- Original message -----
> > On Fri, May 18, 2012 at 3:33 PM, richard -rw- weinberger
> > <richard.weinberger@gmail.com> wrote:
> > > 
> > > On Thu, May 17, 2012 at 9:50 PM, Auke Kok <auke-jan.h.kok@intel.com>
> > > wrote:
> > > > Add a simple trace event for capable().
> > > > 
> > > > There's been a lot of discussion around capable(), and there
> > > > are plenty of tools to help reduce capabilities' usage from
> > > > userspace. A major gap however is that it's almost impossible
> > > > to see or verify which bits are requested from either userspace
> > > > or in the kernel.
> > > > 
> > > > This patch adds a minimal tracer that will print out which
> > > > CAPs are requested and whether the request was granted.
> > > 
> > > Can we please have support for user namespaces?
> > > At least idicate whether the current namespace is init_user_ns or not.
> > 
> > that was the main reason for sending this out already - that should be
> > trivial to add to the trace event, but I haven't looked at namespaces
> > yet myself. I'll check it out.
> > 
> 
> right, trivial to add, but either go through linux-next or wait for Eric's
> patchset to move from there to Linus' tree.  Print the
> from_kuid(&init_user_ns, current_uid()), and if not in init_user_ns then also
> print the ns creator and task uid in his own ns.
> 
> I don't think you need to do that right now.

Oh, you'll also need to add the uid (in init_user_ns) of the owner of
the target namespace ('ns').  Otherwise, the admin may freak out seeing
uid 500 got cap_sys_admin :)

-serge
