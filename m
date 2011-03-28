Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1C1RY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab1C1RYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:24:55 -0400
Date: Mon, 28 Mar 2011 13:24:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
Message-ID: <20110328172447.GE7226@redhat.com>
References: <20110322150905.GD3757@redhat.com>
 <AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
 <20110322181231.GJ3757@redhat.com>
 <AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
 <20110323204146.GK13315@redhat.com>
 <AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
 <20110325213202.GB21593@redhat.com>
 <AANLkTikTLCdHceaD98zxw90Qb=PuTvfALWELa=Yp6UAC@mail.gmail.com>
 <20110328131503.GA7226@redhat.com>
 <AANLkTinwmTjD-Q19U5nCPvoqN2DYGwtLDgeR8h39uWCX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinwmTjD-Q19U5nCPvoqN2DYGwtLDgeR8h39uWCX@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 09:59:54AM -0700, Chad Talbott wrote:
> On Mon, Mar 28, 2011 at 6:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Mar 25, 2011 at 04:53:13PM -0700, Chad Talbott wrote:
> >> Also, we'll soon be working to adopt the hierarchy series, and we'll
> >> likely revisit using an RT service tree there.  It's difficult to
> >> justify introducing RT service tree before those patches arrive.
> >
> > So once you move to hierachicy series, will be you using RT class and
> > use throttling and abandon this functionality?
> 
> I'll certainly investigate using RT class and throttling, but it's too
> early to know.  It's a known change in behavior, so it will need
> testing (as well as the user-space work to handle the different
> interface).

So why not assess that now and then go for the one which meets your
requirements in long term. If we introduce this patch now, this 
introduces a new user visible interface and we can't get rid of it
later. If two releases down the line you implement RT group functionality
and move to that, then we have this dead interface not being used.

So why not implement RT groups internally (It should be a huge patch) now
and test and see how well is it working with throttling logic and whether
it meets your needs or not.

Thanks
Vivek
