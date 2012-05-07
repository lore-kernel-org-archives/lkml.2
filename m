Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2EGVBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:01:49 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab2EGVBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:01:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
Date: Mon, 7 May 2012 23:06:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, Huang Ying <ying.huang@intel.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <201205042255.13508.rjw@sisk.pl> <CAC=cRTOtkr3ABY=0yxnRrwCVa3p5+Ghx9+c2AqzxXwO6ZaHMfg@mail.gmail.com>
In-Reply-To: <CAC=cRTOtkr3ABY=0yxnRrwCVa3p5+Ghx9+c2AqzxXwO6ZaHMfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072306.35163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, huang ying wrote:
> On Sat, May 5, 2012 at 4:55 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, May 04, 2012, Bjorn Helgaas wrote:
> >> On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
> >> > From: Zheng Yan <zheng.z.yan@intel.com>
> >> >
> >> > This patch adds runtime PM support to PCIe port.  This is needed by
> >> > PCIe D3cold support, where PCIe device in slot may be powered on/off
> >> > by PCIe port.
> >>
> >> I assume this works for integrated PCIe devices as well as those that
> >> are plugged into a slot and can be physically removed -- maybe the
> >> text "in slot" is superfluous?
> >>
> >> > Because runtime suspend is broken for some chipset, a white list is
> >> > used to enable runtime PM support for only chipset known to work.
> >>
> >> A whitelist requires perpetual maintenance.  Every time a new working
> >> chipset comes out, you have to update the whitelist.  That doesn't
> >> seem right.
> >
> > Well, we can't possibly enable the feature for all PCIe ports in existence
> > either, because some of them will not work with it (almost surely).
> 
> What do you think about the idea from Bjorn to use some kind of blacklist here?

Whitelists are much better than blacklists for new features IMO, because they
allow the feature to be enabled on more and more existing systems over time
(as they are tested) and it's easy to revert wrong enablements (eg. if
a system is added to a whitelist and it turns out not to work afterward, it's
sufficient to remove the whitelist entry to fix the problem).

A general rule for adding new features should be that the feature is only
enabled on systems where it is _known_ to work or at the user's request.

Thanks,
Rafael
