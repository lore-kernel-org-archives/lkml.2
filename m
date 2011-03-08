Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1CHJDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:03:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46885 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1CHJCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:02:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Nj3kME+oXN5t5Lm+WtBc1TfoEBF7v8mVl2tQaUvGs8cLZP70VudsErB5mZ3usVuIOt
         idYhBBhyOQH0AUV0jFkevt/8JfU8Y66c9bchFO1HnFaB1eEaUNKduP5Jt+qZ3Zapd75M
         VrG0wDKmI+LgDbPGOueLRYShaw/brrsJjUCPw=
Date: Tue, 8 Mar 2011 11:02:47 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler.patch added to -mm
 tree
Message-ID: <20110308090247.GA20281@p183.telecom.by>
References: <201103072305.p27N5hKT000474@imap1.linux-foundation.org>
 <20110307232655.GA7234@p183.telecom.by>
 <AANLkTi=-PcbpBjWZuno1fjwZD-tGmC+JMxrzMr1FNwu7@mail.gmail.com>
 <AANLkTikxbAfpHCWzvLscdHccOju=Q1tN0pvcu_=jbeQ_@mail.gmail.com>
 <20110308082409.GA4913@p183.telecom.by>
 <AANLkTik2qpLnxUfD9NyPFSbO5PyYFeRv8cM=Nz1t=UOZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik2qpLnxUfD9NyPFSbO5PyYFeRv8cM=Nz1t=UOZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 04:43:36PM +0800, Dave Young wrote:
> On Tue, Mar 8, 2011 at 4:24 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > On Tue, Mar 08, 2011 at 01:43:31PM +0800, Dave Young wrote:
> >> On Tue, Mar 8, 2011 at 1:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >> > On Tue, Mar 8, 2011 at 7:26 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >> >> On Mon, Mar 07, 2011 at 03:05:43PM -0800, akpm@linux-foundation.org wrote:
> >> >>> Add a proc_dointvec_unsigned() sysctl handler for positive value cases.
> >> >>
> >> >>> --- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler
> >> >>> +++ a/kernel/sysctl.c
> >> >>
> >> >>> +int proc_dointvec_unsigned(struct ctl_table *table, int write,
> >> >>> +               void __user *buffer, size_t *lenp, loff_t *ppos)
> >> >>> +{
> >> >>> +     struct do_proc_dointvec_minmax_conv_param param = {
> >> >>> +             .min = &zero,
> >> >>> +     };
> >> >>> +     return do_proc_dointvec(table, write, buffer, lenp, ppos,
> >> >>> +                             do_proc_dointvec_minmax_conv, &param);
> >> >>> +}
> >> >>
> >> >> This silently ignored max value in .extra2 .
> >> >
> >> > Hi,
> >> >
> >> > Good cache, should set .max = NULL here
> >>
> >> Oh, c99 set default value to 0, isn't it?
> >>
> >> What do you mean silently ignore here?
> >>
> >> Let's see the code:
> >>
> >>  if ((param->min && *param->min > val) ||
> >>                     (param->max && *param->max < val))
> >>                     return -EINVAL;
> >>
> >> There's no problem max == NULL
> >
> > I mean literally "silently ignore".
> >
> > Try
> >        {
> >                .name = "foo",
> >                .data = &foo,
> >                .maxlen = sizeof(foo),
> >                .proc_handler = proc_dointvec_unsigned,
> >                .extra2 = &_42,
> >        }
> >
> 
> Yes, extra2 is ignored,  what would you like to do for this kind of ignore?

Obviously it should remain upper bound.
