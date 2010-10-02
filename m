Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab0JBE7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 00:59:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54478 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0JBE7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 00:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GA7uamnQ6f0/ib3tULm4z2D88HuNpO8I13SrpZNv7S4++JegKXQmDw+CuZAJNdNC6d
         2+kSYJJjVUjS+3jxdplnwW+7Y8yDRjbUdQqQx+borblhdCCK3TTB23z4+hc1DKaN1D1/
         hbyWuv+yXnmsXuD++2Ss4Il0N3DKMjlGgRPLM=
Subject: Re: [PATCH RESEND v3 09/24] ptrace: cleanup arch_ptrace() on frv
From: Namhyung Kim <namhyung@gmail.com>
To: "Daniel K." <dk@uw.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
In-Reply-To: <1285991879.1696.4.camel@leonhard>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
	 <1285838880-4977-10-git-send-email-namhyung@gmail.com>
	 <4CA6A484.8000109@uw.no>  <1285991879.1696.4.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 13:59:11 +0900
Message-ID: <1285995551.1696.19.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-02 (토), 12:57 +0900, Namhyung Kim:
> 2010-10-02 (토), 03:18 +0000, Daniel K.:
> > Namhyung Kim wrote:
> > >       case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
> > >             ret = -EIO;
> > -             if ((addr & 3) || addr < 0)
> > +             if (addr & 3)
> >                     break;
> >
> > > -		ret = 0;
> > > -		switch (addr >> 2) {
> > > +		switch (regno) {
> > >  		case 0 ... PT__END - 1:
> > > -			ret = put_reg(child, addr >> 2, data);
> > > -			break;
> > > -
> > > -		default:
> > > -			ret = -EIO;
> > > +			ret = put_reg(child, regno, data);
> > >  			break;
> > >  		}
> > >  		break;
> > 
> > With this, you remove the default case, and no longer return -EIO in the
> > cases of PT__END + n, as in the PTRACE_PEEKUSR section above.
> > 
> > This is a change of behaviour as far as I can tell, and not just a cleanup.
> > 
> > 
> > Daniel K.
> 
> My bad. It should be my mistake. Will resend the fix soon.
> Thanks.
> 
> 

My mistake, again. I was bit confused.

It would not be a change of behaviour. Because 'ret' was initialized
with -EIO and only changed in the switch case. So assignment before
switch can be removed and then will return -EIO in default case.

Thanks.


-- 
Regards,
Namhyung Kim


