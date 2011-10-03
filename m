Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1JCQSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:18:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51773 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1JCQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:18:28 -0400
Date: Mon, 3 Oct 2011 12:18:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/9] xen/pciback: Return proper error code
 from sscanf.
Message-ID: <20111003161809.GD17108@phenom.oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-3-git-send-email-konrad.wilk@oracle.com>
 <4E858FB60200007800058A99@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E858FB60200007800058A99@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A02020B.4E89E051.0150:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:45:26AM +0100, Jan Beulich wrote:
> >>> On 29.09.11 at 21:52, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > . instead of just hardcoding it to be -EINVAL.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/xen-pciback/pci_stub.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/xen/xen-pciback/pci_stub.c 
> > b/drivers/xen/xen-pciback/pci_stub.c
> > index 32d6891..d985b65 100644
> > --- a/drivers/xen/xen-pciback/pci_stub.c
> > +++ b/drivers/xen/xen-pciback/pci_stub.c
> > @@ -868,7 +868,7 @@ static inline int str_to_slot(const char *buf, int 
> > *domain, int *bus,
> >  	if (err == 4)
> >  		return 0;
> >  	else if (err < 0)
> > -		return -EINVAL;
> > +		return err;
> >  
> >  	/* try again without domain */
> >  	*domain = 0;
> 
> This should then also be done for the final return from the function:
> 
> 	return err < 0 ? err : -EINVAL;
> 
> But: Where did you read that {v,}sscanf() would return -E... values in
> hypothetical error cases? The C standard says it would return EOF
> when reaching the end of the input string before doing the first
> conversion; lib/vsprintf.c doesn't do so, and also doesn't say it might
> return -E... codes. Bottom line is that I think the code is more correct
> the way it is without this change.

will drop the patch..
