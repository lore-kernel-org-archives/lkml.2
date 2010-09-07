Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0IGFnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:43:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35746 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0IGFm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=R7huxsHAH9b71tBMV7hTajK3Qulev3iskkeiKqk9AuLAI56QYHWYr/E2xvE/J1tmIV
         lc9JcsPplOK9QRML4V1X2zTSjf09ZjrMvT5CdXcN46qckj7BlTadJ+UjriTVMkTplxfc
         0ut9mWxOab3Thamzg5EwQOEJ2MYSabcgcHcAU=
Date: Mon, 6 Sep 2010 22:42:52 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Message-ID: <20100907054252.GA25651@gvim.org>
Reply-To: markgross@thegnar.org
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
 <87hbigqg8d.fsf@deeprootsystems.com>
 <20100902140546.GA2818@gvim.org>
 <201009022209.20354.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009022209.20354.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 10:09:20PM +0200, Rafael J. Wysocki wrote:
> On Thursday, September 02, 2010, mark gross wrote:
> > On Fri, Aug 27, 2010 at 07:31:46AM -0700, Kevin Hilman wrote:
> > > Saravana Kannan <skannan@codeaurora.org> writes:
> > > 
> > > > Some drivers/devices might need some minimum system bus performance to
> > > > provide acceptable service. Provide a PM QoS parameter to send these requests
> > > > to.
> > > >
> > > > The new parameter is named "system bus performance" since it is generic enough
> > > > for the unit of the request to be frequency, bandwidth or something else that
> > > > might be appropriate. It's up to each implementation of the QoS provider to
> > > > define what the unit of the request would be.
> > > >
> > > > Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> > > 
> > > With this current design, only one system-wide bus would be managed.
> > > What if a platform has more than one independently scalable bus?
> > > 
> > > I think the only scalable way to handle this kind of thing is to have
> > > per-device QoS constraints that can then be combined/aggregated by parent
> > > devices/busses.
> > > 
> > > At LPC this year, I've proposed per-device QoS constraints[1] as a topic
> > > for the PM mini-conf.  I hope some folks from the MSM camp can be there
> > > for these discussions.
> > > 
> > > Kevin
> > > 
> > > [1] http://www.linuxplumbersconf.org/2010/ocw/proposals/819
> > 
> > I thought a pm_qos like thing per bus would be a patch or you where
> > going to put up to the driver model. ;)
> > 
> > The current pm_qos would stick around for higher level pm_qos things.
> > So making the system bus and changing to a summation aggregation would
> > be  temporary thing.  
> > 
> > Or are you you saying we shouldn't put system_bus into pm_qos at all and
> > instead we should put effort into adding it to the driver model for
> > buses?
> 
> Hmm, well, what's system_bus?
> 
> Rafael

My understanding is that system_bus is a somewhat generic concept that
has meaning only in platform specific hardware configurations pm_qos
request class for device specific buses.  Memory, SDIO, SPI, i2c etc.

I'm not sure if it should be exposed up to user mode as an ABI.  Its
pretty abstract and its meaning is perhaps a bit mutable across target 
architectures at this time.

--mgross



