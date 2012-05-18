Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967025Ab2ERXTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:19:53 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:43422 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2ERXTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:19:49 -0400
From: Serge Hallyn <serge@hallyn.com>
Reply-To: Serge Hallyn <serge@hallyn.com>
To: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] Trace event for capable().
X-Mailer: Modest 3.2
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
	 <CAFLxGvzZ_YJS25wK=YHCELwJOZZuhdeoB6S5Yw_TMVEXzTofOg@mail.gmail.com>
	  <CABsxX9JWK1qVubuYt0+HoZy-Lhz0kp6a3MxyT7ny5YzLS2rMJQ@mail.gmail.com>
In-Reply-To: <CABsxX9JWK1qVubuYt0+HoZy-Lhz0kp6a3MxyT7ny5YzLS2rMJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-ID: <1337383163.1463.1.camel@Nokia-N900-51-1>
Date: Fri, 18 May 2012 18:19:23 -0500
Message-Id: <1337383163.1463.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original message -----
> On Fri, May 18, 2012 at 3:33 PM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
> > 
> > On Thu, May 17, 2012 at 9:50 PM, Auke Kok <auke-jan.h.kok@intel.com>
> > wrote:
> > > Add a simple trace event for capable().
> > > 
> > > There's been a lot of discussion around capable(), and there
> > > are plenty of tools to help reduce capabilities' usage from
> > > userspace. A major gap however is that it's almost impossible
> > > to see or verify which bits are requested from either userspace
> > > or in the kernel.
> > > 
> > > This patch adds a minimal tracer that will print out which
> > > CAPs are requested and whether the request was granted.
> > 
> > Can we please have support for user namespaces?
> > At least idicate whether the current namespace is init_user_ns or not.
> 
> that was the main reason for sending this out already - that should be
> trivial to add to the trace event, but I haven't looked at namespaces
> yet myself. I'll check it out.
> 

right, trivial to add, but either go through linux-next or wait for Eric's patchset to move from there to Linus' tree.  Print the from_kuid(&init_user_ns, current_uid()), and if not in init_user_ns then also print the ns creator and task uid in his own ns.

I don't think you need to do that right now.

> Auke
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at   http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at   http://www.tux.org/lkml/

