Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0GLVwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:52:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55599 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0GLVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WAwC2TfZgPns4H5J1cEsYLkewY7h08uc48kluKt4QTyZUa3QCByDUcS8DZ+PfvR3A0
         908dPDI2sQUe/k8oFn6luuwGur8vDuqOzpP7lSG2J4b8usHoGwrUT8FvOcdyXcfrfMUx
         L0notqBELmQLOdxzpxmQZwXcJQMbN6mY8hM1c=
Date: Mon, 12 Jul 2010 23:51:01 +0200
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Abhishek Kulkarni <adkulkar@umail.iu.edu>,
        Venkateswararao Jujjuri <jvrao@us.ibm.com>,
        linux-kernel@vger.kernel.org, Tilman Sauerbeck <tilman@code-monkey.de>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] 9p: strlen() doesn't count the terminator
Message-ID: <20100712215101.GG5658@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Abhishek Kulkarni <adkulkar@umail.iu.edu>,
	Venkateswararao Jujjuri <jvrao@us.ibm.com>,
	linux-kernel@vger.kernel.org,
	Tilman Sauerbeck <tilman@code-monkey.de>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100710095154.GU19184@bicker> <20100712130458.bb8ae751.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100712130458.bb8ae751.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 01:04:58PM -0700, Andrew Morton wrote:
> > diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> > index 98ce9bc..c85109d 100644
> > --- a/net/9p/trans_fd.c
> > +++ b/net/9p/trans_fd.c
> > @@ -948,7 +948,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
> >  
> >  	csocket = NULL;
> >  
> > -	if (strlen(addr) > UNIX_PATH_MAX) {
> > +	if (strlen(addr) >= UNIX_PATH_MAX) {
> >  		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
> >  			addr);
> >  		return -ENAMETOOLONG;
> 
> This bug doesn't strike me as serious enough to warrant backporting the fix
> into -stable.  What was your thinking there?

I don't feel strongly about it.  It's safe enough and it applies
cleanly.  On the other hand, root should always control the name of the
device to mount so it's not a big deal.

regards,
dan carpenter
