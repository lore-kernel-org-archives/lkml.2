Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1BKHbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:31:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab1BKHbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:31:11 -0500
Date: Thu, 10 Feb 2011 23:31:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: pratyush <pratyush.anand@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH V3 1/1] ST SPEAr: PCIE gadget suppport
Message-Id: <20110210233100.e12e8f6a.akpm@linux-foundation.org>
In-Reply-To: <4D54E39C.6070306@st.com>
References: <1296742149-18102-1-git-send-email-pratyush.anand@st.com>
	<20110209152926.0126ac97.akpm@linux-foundation.org>
	<4D53B4C1.5080804@st.com>
	<20110210125256.609a1143.akpm@linux-foundation.org>
	<4D54E39C.6070306@st.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011 12:52:04 +0530 pratyush <pratyush.anand@st.com> wrote:

> >>> This interface implies that there will only ever be one device in the
> >>> machine, yes?  Seems a bit short-sighted?
> >>>
> >>
> >> This device supports only one BAR in EP mode.
> > 
> > I don't understand that.
> > 
> > What happens if someone builds a computer with three of these devices
> > in it?
> > 
> 
> I understood it. I will modify the code to work with multiple instances of
> pcie device.

I don't think you need to go that far, unless you see a significant
likelihood think that such a computer might be created one day.  This
depends on how hard and risky such a change is, of course.

But the current driver's userspace interface should at least
anticipate the possibility, so you aren't trapped into a weird or
non-back-compatible interface in the future.

So for now you might choose to do something as simple as renaming
/config/pcie-gadget to /config/pcie-gadget0 and leave it at that.

