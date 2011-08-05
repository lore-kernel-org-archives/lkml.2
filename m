Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1HERrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:47:51 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:56675 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1HERrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:47:49 -0400
Date: Fri, 5 Aug 2011 13:47:28 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110805174728.GA1741@flamenco.cs.columbia.edu>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch>
 <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
 <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3BB6E7.6020809@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 10:24:55 +0100, Martyn Welch wrote:
> I think that by refcounting the resources being used we
> will know whether a bridge module is being used or not,
> thus whether it can be unloaded or not.

But the granularity is wrong; if you want to know whether the
bridge is being used, just keep track of the devices *which
want to make known* that they're under the bridge.

> By reference counting the use of resources we minimise the
> chance of poorly written drivers using resources, but not
> registering the fact that they are in fact using a VME bridge.

A driver leaking a resource will then leave a bogus refcount
on the bus driver--a clear case of self-inflicted pain.

The argument of "poorly written drivers" does not apply;
I would expect all the merged drivers to be "good quality"
only, that's why we want to be upstream and why we put effort
in reviewing. Your point is well-intentioned, but in
practice we'd be shooting ourselves in the foot, potentially
ending up with an unremovable vme bridge module--which is
worse than a driver leaking a resource.

Refcounting must be kept simple & stupid; doing it behind the
backs of the drivers we're trying to protect is a mistake.

		Emilio
