Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1K1TzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:55:14 -0500
Received: from eazy.amigager.de ([213.239.192.238]:56518 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab1K1TzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:55:10 -0500
Date: Mon, 28 Nov 2011 20:55:34 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, "Artem S. Tashkinov" <t.artem@lycos.com>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
 metering applications has gone crackers
Message-ID: <20111128195533.GA26460@mac.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org,
	"Artem S. Tashkinov" <t.artem@lycos.com>
References: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
 <20111124200553.GA13353@mac.home>
 <20111127110400.GA4672@mac.home>
 <201111271245.57772.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111271245.57772.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 12:45:57 +0100, Rafael J. Wysocki wrote:
> On Sunday, November 27, 2011, Tino Keitel wrote:
> > On Thu, Nov 24, 2011 at 21:05:53 +0100, Tino Keitel wrote:
> > > On Thu, Nov 24, 2011 at 10:30:15 +0000, Artem S. Tashkinov wrote:
> > > > Hello,
> > > > 
> > > > I'd like to report a weird regression in Linux 3.2 (running rc3 now) - all CPU metering applications have gone terribly mad
> > > > under this kernel:
> > > 
> > > I get the same using top, htop and the gnome system monitor with kernel
> > > 3.2 on a Sandy Bridge quad core box, running Debian unstable.
> > 
> > I just tested 3.2-rc2, and see the same bug.
> 
> I'm seeing that too on one of my test boxes, but not all the time
> (i.e. there are periods in which the readings are correct).  The other boxes
> I've tested with 3.2-rc are fine in that respect.
> 
> Also, it seems that it shows 100%-(real load) when it is wrong.  So, it looks
> like there's an overflow somewhere in the CPU load measuring code, at least
> on some CPUs.

Hi,

I reverted this commit and so far it looks good:

commit a25cac5198d4ff2842ccca63b423962848ad24b2
Author: Michal Hocko <mhocko@suse.cz>
Date:   Wed Aug 24 09:40:25 2011 +0200

    proc: Consider NO_HZ when printing idle and iowait times

I'll report back tomorrow how the kernel behaves.

Regards,
Tino
