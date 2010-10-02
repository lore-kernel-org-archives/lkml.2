Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0JBD6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 23:58:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61978 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0JBD6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 23:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=q2WpLjcyCJib5jXQ/PG3xqmhqcM2hKSut0TC8op5dCmLIYO7tQ2f4s+BZnKyfADYfg
         le3mtz11+1RPjUG+ip8h9JmD5iDPCqEBEXPbWOApNk1tG/9nNpEs7YRt2Jigi+Fr/7zD
         3DDywm/XWcfGGL/NhpOo3h5InPdRe2lr9RSDE=
Subject: Re: [PATCH RESEND v3 09/24] ptrace: cleanup arch_ptrace() on frv
From: Namhyung Kim <namhyung@gmail.com>
To: "Daniel K." <dk@uw.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
In-Reply-To: <4CA6A484.8000109@uw.no>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
	 <1285838880-4977-10-git-send-email-namhyung@gmail.com>
	 <4CA6A484.8000109@uw.no>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 12:57:59 +0900
Message-ID: <1285991879.1696.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-02 (토), 03:18 +0000, Daniel K.:
> Namhyung Kim wrote:
> > -		ret = 0;
> > -		switch (addr >> 2) {
> > +		switch (regno) {
> >  		case 0 ... PT__END - 1:
> > -			ret = put_reg(child, addr >> 2, data);
> > -			break;
> > -
> > -		default:
> > -			ret = -EIO;
> > +			ret = put_reg(child, regno, data);
> >  			break;
> >  		}
> >  		break;
> 
> With this, you remove the default case, and no longer return -EIO in the
> cases of PT__END + n, as in the PTRACE_PEEKUSR section above.
> 
> This is a change of behaviour as far as I can tell, and not just a cleanup.
> 
> 
> Daniel K.

My bad. It should be my mistake. Will resend the fix soon.
Thanks.


-- 
Regards,
Namhyung Kim


