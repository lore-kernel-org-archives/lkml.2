Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031176Ab2CVVwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:52:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39972 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030475Ab2CVVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:52:53 -0400
X-Sasl-enc: wSE/ccaHBoBEMF7BqJ310ApAVJ3ZFEZDX95N3ma+H1zu 1332453173
Date: Thu, 22 Mar 2012 14:52:23 -0700
From: Greg KH <greg@kroah.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression introduced in v3.2.12 stable
Message-ID: <20120322215223.GA18689@kroah.com>
References: <4F6B7A37.3020300@canonical.com>
 <20120322212644.GA30888@kroah.com>
 <4F6B9D0E.2040308@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6B9D0E.2040308@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 05:43:42PM -0400, Joseph Salisbury wrote:
> On 03/22/2012 05:26 PM, Greg KH wrote:
> > On Thu, Mar 22, 2012 at 03:15:03PM -0400, Joseph Salisbury wrote:
> >> I figured I'd send a heads up regarding a possible regression in v3.2.12
> >> stable.  The issue prevents systems from booting.
> >>
> >> There have been a few bugs[0] reported against the Ubuntu kernel, which
> >> was recently rebased to 3.2.12.  We're in the process of bisecting now
> >> and will post an update..
> > 
> > What specifically happens here when the system does not boot?  Any error
> > message?  Are you sure this isn't the known pci express issue showing up
> > here?
> > 
> > Can you run 'git bisect' to trace it down to a specific patch please?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
> Thanks for the response.
> 
> We did some bisecting/testing and identified the bad commit in 3.2.12 as
> the following:
> 
> f043ddb60c84ea64a23b755004572afe922e653c PCI: ignore pre-1.1 ASPM
> quirking when ASPM is disabled

Yup, that's the known problem one.  But, note that it does solve other
people's problems at the moment, so you can't just ignore it :)

greg k-h
