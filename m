Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1GFPRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:17:39 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:4724 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1GFPRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:17:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 15/77] Staging: hv: blkvsc: Add the appropriate
 MODULE_ALIAS() line
Thread-Topic: [PATCH 15/77] Staging: hv: blkvsc: Add the appropriate
 MODULE_ALIAS() line
Thread-Index: AQHMLGBHWoQfmHDGWUWeXfLMRVPeHZTed46AgAAKHVCAALhhAIAAH11ggACegQD//4tIEA==
Date: Wed, 6 Jul 2011 15:17:37 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480816D432@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-15-git-send-email-kys@microsoft.com>
 <20110705160621.GC7214@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D27E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110706034228.GA4291@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480816D414@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110706150202.GA3353@kroah.com>
In-Reply-To: <20110706150202.GA3353@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, July 06, 2011 11:02 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> Janssen
> Subject: Re: [PATCH 15/77] Staging: hv: blkvsc: Add the appropriate
> MODULE_ALIAS() line
> 
> On Wed, Jul 06, 2011 at 02:55:12PM +0000, KY Srinivasan wrote:
> > > > I think you mean MODULE_DEVICE_TABLE()?
> > >
> > > Yes, sorry for the typo.
> > >
> > > > I actually went down that path first
> > > > adding code  to  file2alias.c for parsing the vmbus ID table. Given that this
> > > approach
> > > > would make it  impossible to support auto-loading of these drivers
> > > > on many of the released kernels,
> > >
> > > Wait, what?  What is a "released kernel"?  We are working on the
> > > in-kernel patch, we don't care about older distros/releases for this
> > > work at all.  Also, it doesn't make sense at all, why would the change I
> > > asked for make any difference on older distros/kernels?
> >
> > I understand we don't care here about older kernels and I will do what you
> > have suggested. I just wanted to give you the rationale for choices I made:
> > We are currently supporting older distros/kernels using these upstream bits.
> > With the MODULE_ALIAS() approach, since I did not have to change any code
> > outside the hv directory, this was possible. I was mostly concerned about
> > having to make changes to code outside the hv directory and figuring out
> > how to build and propagate these changes (file2alias.c) in older kernels.
> 
> You create a patch like any other patch and give it to the people who
> are stuck with those older kernels.  It shouldn't be that hard, and it
> also shouldn't be something that matters for this mainline work either.
> 
> > > > I chose to go with the MODULE_ALIAS() macro that did not need any
> > > > changes outside our drivers. In both methods, the formatting of the
> > > > name is bus specific since I would be writing the code to parse the
> > > > table in file2alias.c.
> > >
> > > Yes, that is what is needed to be done.
> > >
> > > > Granted, I have been quite unimaginative in my alias names, but I
> > > > thought they were reasonably descriptive. If at all possible, for the
> > > > reasons listed above, I would prefer to use the MODULE_ALIAS() macro
> > > > (I could embed all or part of the guid in the alias). Let me know.
> > >
> > > Please do the correct thing and use MODULE_DEVICE_TABLE().
> >
> > We have four drivers now excluding vmbus and soon we will have only three
> > drivers with the merge of block and stor drivers. Would you still recommend I
> use the
> > full guid to name these drivers.
> 
> Yes, why not?
> 
> > Rather than embedding the entire 128bit guid in module aliases, I was
> > thinking of setting up a more reasonable namespace for these drivers
> > (like what virtio has done for instance). Let me know if this is ok
> > with you if I took that route (mapping the guid to small integers and
> > having these integers be used in alias strings).
> 
> What's the big deal of having a large number as an alias?  Is there some
> constraint here that I am not aware of?

It is certainly easier to deal with a small integer than with 128bit giud and there is
no added benefit dealing with guids since the number of drivers we will support
under vmbus will never exceed a very small number. Having said that, I will go ahead
and embed full guids as you have suggested. So, the aliases for these drivers will be:
vmbus:device guid.

Regards,

K. Y

