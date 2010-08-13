Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338Ab0HMIHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 04:07:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44955 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab0HMIHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 04:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tpWnLUI2maKiIFPWf9G5syDHgsHdsqzHhb0VPVjITtZx1KhPchUDhBmrm1jdkrgOL2
         AMEupMPjRSX5kMEsam4gwhAskIPGKJQvRy1vyj6D5IL8FAow9XNaRceFYXc6bkyLMf5h
         sCK1KzD3l2uYPAriiDLXx/bqAxJI1q8cFEBRA=
Date: Fri, 13 Aug 2010 10:07:23 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: "Development for the MeeGo Project (discussion list)" 
	<meego-dev@meego.com>
Cc: "Wang, Qi" <qi.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [MeeGo-dev] [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588
 driver to 2.6.35
Message-ID: <20100813080723.GB4727@riccoc20.at.omicron.at>
References: <4C612AA4.5040100@dsn.okisemi.com>
 <20100810171343.GE21220@suse.de>
 <002601cb3926$edaf24d0$66f8800a@maildom.okisemi.com>
 <20100811151510.GB9180@suse.de>
 <D5AB6E638E5A3E4B8F4406B113A5A19A28EA26B2@shsmsx501.ccr.corp.intel.com>
 <20100812020027.GA14121@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812020027.GA14121@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 07:00:27PM -0700, Greg KH wrote:
> On Thu, Aug 12, 2010 at 09:13:24AM +0800, Wang, Qi wrote:
> > > Please express yours.  Why do you feel you need these to be ioctls?
> > > What exactly are they doing?  Where is the documentation for them all?
> 
> You forgot to answer this.

I recently introduced a PTP clock infrastructure on the netdev
list. While the patch set is still under review, some necessary
background patches have already been accepted, and the response to the
API has been positive.

One major goal of the framework is to reduce the amount of driver code
need to support a new PTP clock. Another goal is remove the need for
MAC drivers to add a bunch of new, private ioctls just for PTP.

Please take a look at that patch set (latest was v4) and also submit
any PTP code on the netdev list for review.

In any case, a MAC driver that offers time stamping on network packets
must implement the SO_TIMESTAMPING API, which has been a part of Linux
since 2.6.30.

Richard
