Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab0EDPPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:15:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47195 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0EDPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:15:08 -0400
Date: Tue, 4 May 2010 10:14:43 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ashwin Ganti <ashwin.ganti@gmail.com>,
       Greg KH <greg@kroah.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morgan <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kyle Moffett <kyle@moffetthome.net>, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3/3] RFC: p9auth: add p9auth fs
Message-ID: <20100504151443.GA18700@us.ibm.com>
References: <20100427164517.GC7530@us.ibm.com>
 <20100427164139.GA7359@us.ibm.com>
 <4067.1272985037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4067.1272985037@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > +	result = kzalloc(MAX_DIGEST_SIZE, GFP_KERNEL);
> > ...
> > +	ret = crypto_hash_digest(&desc, &sg, plain_text_size, result);
> 
> Does result have to be pre-cleared?
> 
> > +	user_buf = kzalloc(count+1, GFP_KERNEL);
> > +	if (!user_buf)
> > +		goto out;
> > +
> > +	if (copy_from_user(user_buf, buffer, count)) {
> 
> user_buf doesn't need preclearing.  It's just a waste of time.  This occurs
> three times.

Hm, yeah, the first doesn't need it at all, and the latter two
should just kmalloc and set user_buf[count] = '\0'.

thanks,

-serge
