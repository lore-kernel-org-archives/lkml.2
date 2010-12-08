Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0LHQlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:41:51 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:44652
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993Ab0LHQlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:41:49 -0500
Date: Wed, 8 Dec 2010 16:42:35 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, dwalsh@redhat.com,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] syslog: check cap_syslog when dmesg_restrict
Message-ID: <20101208164235.GA21062@mail.hallyn.com>
References: <20101208151901.GA20557@mail.hallyn.com>
 <1291822780.3072.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291822780.3072.40.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> On Wed, 2010-12-08 at 15:19 +0000, Serge E. Hallyn wrote:
> Doesn't this return -EPERM right now?

Yes.

>   I think the code might be
> incorrect today as well......
> 
> I thought the flow was supposed to be
> 
> if (capable(CAP_SYSLOG))
> 	all good
> else if (capable(CAP_SYS_ADMIN))
> 	WARN, but still good for now

I prefer warn and deny.  Otherwise it's too easy to ignore warnings.  So
I prefer the msg to be there to explain why it failed - not that I expect
it to fail for anyone today.

> else
> 	EPERM
> 
> But it looks to me like the flow is
> 
> if (capable(CAP_SYSLOG))
> 	all good
> else if (capable(CAP_SYS_ADMIN))
> 	WARN, EPERM
> else
> 	EPERM
> 
> >  	}

Yup.

-serge
