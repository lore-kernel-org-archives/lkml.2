Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0DUNks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:40:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40419 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab0DUNkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:40:46 -0400
Date: Wed, 21 Apr 2010 08:40:40 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ashwin Ganti <ashwin.ganti@gmail.com>,
       Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Message-ID: <20100421134040.GC16326@us.ibm.com>
References: <20100421012908.GB24251@us.ibm.com>
 <20100421012749.GA21338@us.ibm.com>
 <23120.1271846955@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23120.1271846955@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > +	if (ret == 0)
> > +		commit_creds(new);
> > +	else
> > +		abort_creds(new);
> > +
> > +	return ret;
> 
> If you make this:
> 
> 	if (ret == 0)
> 		return commit_creds(new);
> 	abort_creds(new);
> 	return ret;
> 
> then gcc can tail-call commit_creds(), which is guaranteed to return 0.
> 
> David

Ok, will do.

thanks,
-serge
