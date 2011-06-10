Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab1FJFVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:21:50 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61346 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1FJFVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kKRQUIQyA84gEwvSFkFVTSzlwwVS9rMpSsNSIkIue8C7DyvaDSaGWrSUW5yHJWCeaH
         nioVTweNVYHgHdxH/KuUkSt4jLeAU+rd43CiLpUHZWWN20xcEx2g/Kex/E6WpQq8XkIq
         ECxkjPmPO7ZcU6iZR1EMh3Yc+uZqaAchXz24w=
Date: Fri, 10 Jun 2011 13:20:50 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, arvino55@gmail.com
Subject: Re: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
Message-ID: <20110610052047.GB3643@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org, arvino55@gmail.com
References: <20110609030401.GA2615@gmail.com>
 <20110609103747.59805668.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20110609103747.59805668.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 10:37:47AM -0700, Randy Dunlap wrote:
> On Thu, 9 Jun 2011 11:04:13 +0800 Harry Wei wrote:
> 
> > -	page = (unsigned long) info->eap;
> > +	page = (unsigned long long) info->eap;
> 
> But page is still unsigned long, not unsigned long long...
Yup, but if we can define a 'unsigned long long' type?
> 
> >  	if (info->xeap & 1)
> > -		page |= 0x100000000ul;
> > +		page |= 0x100000000ull;
> 
> and just making this second change fixes the warning.
I will try my best. Can anyone give some other comments?
> 
> I don't know what the right answer is, but this patch does not look
> complete to me.
I will try to give a v2.
> 
> Back in April there was a discussion about this warning message and the
> conclusion was that this driver should be replaced.  See
> https://lkml.org/lkml/2011/4/21/232 and its replies.
> But we seem to be having problems reaching the EDAC subsystem maintainer
> (again cc-ed).
You have not got a exact conclusion about this warning.
Maybe Arvind knows more about this warning.(cc'ed)


Thanks
Harry Wei
