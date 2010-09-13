Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0IMOLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:11:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab0IMOLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:11:54 -0400
Date: Mon, 13 Sep 2010 10:11:40 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913141140.GB27371@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-5-git-send-email-ying.huang@intel.com>
 <20100910160211.GH4879@redhat.com>
 <20100910181929.4f35ab7c@basil.nowhere.org>
 <20100910184039.GK4879@redhat.com>
 <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:19:49AM +0800, Huang Ying wrote:
> On Sat, 2010-09-11 at 02:40 +0800, Don Zickus wrote:
> > On Fri, Sep 10, 2010 at 06:19:29PM +0200, Andi Kleen wrote:
> > > 
> > > > I am grasping for straws here, but is there a register that APEI/HEST
> > > > can poke to see if it generated the NMI?
> > > 
> > > HEST knows this yes.
> > > 
> > > But this is not about HEST errors, but about those without HEST
> > > handling.
> > 
> > Don't most unknown NMIs fall into the same boat, that they were not being
> > handled properly?
> 
> As far as I know, at least on some platforms, unknown NMIs are used for
> hardware error reporting. They will cause "Blue Screen" in Windows.

Unfortunately, most of the bugzillas I deal with, unkown NMIs are the
result of SERRs.  While you can consider that hardware error reporting,
the easiest way for me to debug those problems currently is to have
reporters run 'lspci -vvv' after the NMI is displayed to figure out who
caused the NMI.

My fear is that panic'ing the box on unknown NMIs on those platforms will
hinder my ability to easily debug those NMIs.

> 
> > On the other hand could you use the die_notifier_chain(DIE_UNKNOWNNMI) for
> > the same purpose and keep the unknown_nmi_error() handler a little
> > cleaner?
> 
> I think explicit function call has better readability than notifier
> chain.

Ok.  What criteria should we establish to determine which functions go on
the notifier chain and which ones can explicitly called?

Cheers,
Don
