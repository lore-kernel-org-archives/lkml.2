Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1K2VZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:25:31 -0500
Received: from eazy.amigager.de ([213.239.192.238]:51041 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1K2VZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:25:29 -0500
Date: Tue, 29 Nov 2011 22:25:54 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Artem S. Tashkinov" <t.artem@lycos.com>
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
 metering applications has gone crackers
Message-ID: <20111129212554.GA2955@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Artem S. Tashkinov" <t.artem@lycos.com>
References: <1718181782.740375.1322130615898.JavaMail.mail@webmail19>
 <20111124200553.GA13353@mac.home>
 <20111127110400.GA4672@mac.home>
 <201111271245.57772.rjw@sisk.pl>
 <20111128195533.GA26460@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128195533.GA26460@mac.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 20:55:34 +0100, Tino Keitel wrote:
> On Sun, Nov 27, 2011 at 12:45:57 +0100, Rafael J. Wysocki wrote:
> > On Sunday, November 27, 2011, Tino Keitel wrote:
> > > On Thu, Nov 24, 2011 at 21:05:53 +0100, Tino Keitel wrote:
> > > > On Thu, Nov 24, 2011 at 10:30:15 +0000, Artem S. Tashkinov wrote:
> > > > > Hello,
> > > > > 
> > > > > I'd like to report a weird regression in Linux 3.2 (running rc3 now) - all CPU metering applications have gone terribly mad
> > > > > under this kernel:
> > > > 
> > > > I get the same using top, htop and the gnome system monitor with kernel
> > > > 3.2 on a Sandy Bridge quad core box, running Debian unstable.
> > > 
> > > I just tested 3.2-rc2, and see the same bug.
> > 
> > I'm seeing that too on one of my test boxes, but not all the time
> > (i.e. there are periods in which the readings are correct).  The other boxes
> > I've tested with 3.2-rc are fine in that respect.
> > 
> > Also, it seems that it shows 100%-(real load) when it is wrong.  So, it looks
> > like there's an overflow somewhere in the CPU load measuring code, at least
> > on some CPUs.
> 
> Hi,
> 
> I reverted this commit and so far it looks good:
> 
> commit a25cac5198d4ff2842ccca63b423962848ad24b2
> Author: Michal Hocko <mhocko@suse.cz>
> Date:   Wed Aug 24 09:40:25 2011 +0200
> 
>     proc: Consider NO_HZ when printing idle and iowait times
> 
> I'll report back tomorrow how the kernel behaves.

Hi,

looks fine so far with the git tree from commit
401d0069cb344f401bc9d264c31db55876ff78c0 and
a25cac5198d4ff2842ccca63b423962848ad24b2 reverted.

Regards,
Tino
