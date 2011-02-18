Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab1BRWQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:16:08 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:24748 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1BRWQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:16:07 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Thread-Topic: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Thread-Index: AQHLzUkvKd3MYDWV20OaBRjCSuUWD5QITSqA//+CNECAAIydAP//es7A
Date: Fri, 18 Feb 2011 22:16:05 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E04801162F@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com>
 <20110218211423.GH796@kroah.com>
 <6E21E5352C11B742B20C142EB499E048011604@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110218220724.GA28986@suse.de>
In-Reply-To: <20110218220724.GA28986@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, February 18, 2011 5:07 PM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> 
> On Fri, Feb 18, 2011 at 10:00:04PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Friday, February 18, 2011 4:14 PM
> > > To: KY Srinivasan
> > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > > Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> > >
> > > On Tue, Feb 15, 2011 at 11:55:35AM -0800, K. Y. Srinivasan wrote:
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > >
> > > You didn't run this through checkpatch.pl.
> > >
> > > Please do so and fix the warning it gives you.
> > Greg, I did run the checkpatch script against this patch and the only
> > complaint I got was with regards to the IRQF_SAMPLE_RANDOM flag that I
> > pass. As a virtual machine, this is the only external event that the
> > VM is going to see and so I chose to keep this flag.  Is there
> > something that would replace this flag; looking at the Xen drivers
> > they do pass this flag.
> 
> But that flag is going away, right?  And this really can't be a valid
> source of entropy as the HV channel is pretty predictable.

Is it going away? What would replace this. Is all interrupt sources considered
predictable? This is the only unpredictable thing happening in the VM and that is the reason
I chose to keep the flag.
> 
> If you are only using this because Xen does/did it, that's not a valid
> excuse :)
Surely, you are joking. In any event I am sending you a new patch with that flag removed.

Regards,

K. Y


> 
> thanks,
> 
> greg k-h

