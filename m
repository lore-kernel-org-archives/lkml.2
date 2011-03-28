Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1C1NRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab1C1NRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:17:15 -0400
Date: Mon, 28 Mar 2011 09:17:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
Message-ID: <20110328131705.GB7226@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
 <20110322150905.GD3757@redhat.com>
 <AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
 <20110322181231.GJ3757@redhat.com>
 <AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
 <20110323204146.GK13315@redhat.com>
 <AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
 <20110325213202.GB21593@redhat.com>
 <AANLkTikTLCdHceaD98zxw90Qb=PuTvfALWELa=Yp6UAC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikTLCdHceaD98zxw90Qb=PuTvfALWELa=Yp6UAC@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 04:53:13PM -0700, Chad Talbott wrote:
> On Fri, Mar 25, 2011 at 2:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> You seem pretty unenthusiastic about a).  How do you feel about b)?
> >
> > IMHO, Using RT group with throttling avoids introducing asymmetry between
> > task and group attributes. So I will prefer that approch. Though it means
> > more code as we will be introducing RT groups but that might be useful
> > in general for something else too. (I am assuming that somebody makes
> > use of RT class for cfqq).
> >
> > The one more down side of trying to use throttling is that one needs to
> > come up with absolute limit. So one shall have to know disk capacity
> > and if there are no BE tasks running then latency sensitive task will
> > be unnecessarily throttled (until and unless some management software
> > can monitor it and change limit dynamically).
> >
> > So if you are worried about setting the absolute limit part, then I guess
> > I am fine with option a). But if you think that setting absolute limit
> > is not a problem, then option b) is preferred.
> 
> I prefer option a) - so much so that even with the older CFQ group
> implementation we did work to merge the RT and BE service trees to
> achieve that behavior.  But I see that using blkio.class is a poor
> choice of interface name.  I will rename the interface and resubmit
> the patch series (also with Gui's suggestion to keep the "_device"
> suffix for consistency).

Do you need this feature to be global or per device or both?

Thanks
Vivek
