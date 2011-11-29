Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1K2R4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:56:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580Ab1K2R4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:56:05 -0500
Date: Tue, 29 Nov 2011 18:56:03 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ian Kumlien <pomac@vapor.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, tino.keitel@tikei.de,
        t.artem@lycos.com
Subject: Re: [REGRESSION] [Linux 3.2] top/htop and all other CPU usage
Message-ID: <20111129175537.GA10356@tiehlicka.suse.cz>
References: <20111128222803.GA4925@pomac.netswarm.net>
 <20111129075242.GB2675@tiehlicka.suse.cz>
 <1322587860.4061.6.camel@pi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322587860.4061.6.camel@pi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-11-11 18:31:00, Ian Kumlien wrote:
> On tis, 2011-11-29 at 08:52 +0100, Michal Hocko wrote:
> > On Mon 28-11-11 23:28:03, pomac@vapor.com wrote:
> > > Hi, 
> > > 
> > > All this time i have been thinking i'm the only one - and i've been to
> > > loaded with work during working hours and tired when home =P
> > > 
> > > Anyways, I've neen seeing this since -rc1 on:
> > > Intel(R) Core(TM) i5 CPU U520  @ 1.07GHz - x86-64
> > > AMD Phenom(tm) II X6 1090T - x86-64
> > > AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ - x86-64
> > > Intel(R) Core(TM)2 CPU T7200  @ 2.00GHz - i686
> > > 
> > > Configs available on demand - I've been running the same config for
> > > quite some time though.
> > 
> > As I have written in other email could you post your config and collect
> > the following data?
> > for i in `seq 30`; 
> > do 
> >         cat /proc/stat > `date +'%s'`
> >         sleep 1
> > done
> > export old_user=0 old_nice=0 old_sys=0 old_idle=0 old_iowait=0; 
> > 
> > # for all your available CPUs
> > grep cpu0 * | while read cpu user nice sys idle iowait rest; 
> > do 
> >         echo $cpu $(($user-$old_user)) $(($nice-$old_nice)) $(($sys-$old_sys)) $(($idle-$old_idle)) $(($iowait-$old_iowait))
> >         old_user=$user old_nice=$nice old_sys=$sys old_idle=$idle old_iowait=$iowait
> > done
> 
> Sorry, the previous one was AMD X2 4400+ and now the T7200:
> 
> 1322587696:cpu0 1410110 148 368843 357890604 357890604
> 1322587697:cpu0 0 0 1 0 0
> 1322587698:cpu0 1 0 1 0 0
> 1322587699:cpu0 2 0 1 0 0
> 1322587700:cpu0 0 0 1 0 0
> 1322587701:cpu0 0 0 1 0 0
> 1322587702:cpu0 0 0 1 0 0
> 1322587703:cpu0 1 0 0 0 0
> 1322587704:cpu0 0 0 0 0 0
> 1322587705:cpu0 0 0 1 0 0
> 1322587706:cpu0 1 0 1 0 0
> 1322587707:cpu0 0 0 1 0 0
> 1322587708:cpu0 1 0 0 0 0
> 1322587709:cpu0 1 0 0 0 0
> 1322587711:cpu0 0 0 2 0 0
> 1322587712:cpu0 0 0 0 0 0
> 1322587713:cpu0 1 0 1 0 0
> 1322587714:cpu0 1 0 0 0 0
> 1322587715:cpu0 1 0 1 0 0
> 1322587716:cpu0 1 0 0 0 0
> 1322587717:cpu0 0 0 1 0 0
> 1322587718:cpu0 1 0 1 0 0
> 1322587719:cpu0 0 0 1 0 0
> 1322587720:cpu0 0 0 0 0 0
> 1322587721:cpu0 2 0 1 0 0
> 1322587722:cpu0 1 0 0 0 0
> 1322587723:cpu0 0 0 3 0 0
> 1322587724:cpu0 1 0 0 0 0
> 1322587725:cpu0 0 0 0 0 0
> 1322587726:cpu0 0 0 1 0 0

OK, so the same thing as in another email in the thread (no idle/io_wait
accounting).
Could you double check what kind of idle driver are you using?
cat /sys/devices/system/cpu/cpuidle/current_driver
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
