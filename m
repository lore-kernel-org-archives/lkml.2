Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2DEOkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:40:13 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58602 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2DEOkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:40:11 -0400
Date: Thu, 5 Apr 2012 07:39:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal CHAPPERON <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120405143918.GE27672@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120404152726.GB16299@zod.bos.redhat.com>
 <20120404213633.GI2302@linux.vnet.ibm.com>
 <20120405123759.GE1963@zod.bos.redhat.com>
 <20120405140006.GB27672@linux.vnet.ibm.com>
 <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1838583439.163624.1333635333132.JavaMail.www@wwinf1m19>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040514-5518-0000-0000-00000378F78D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 04:15:33PM +0200, Pascal CHAPPERON wrote:
> Hello,
> 
> I didn't notice any significant slowdown while the system is up and running. A full kernel compilation (make -j 16) takes 14mn with both 3.2.10 and 3.3.0.

OK, so the natural approach is to disable CONFIG_RCU_FAST_NO_HZ at
boot time.  Unfortunately, you appear to need it to remain disabled
through at least filesystem mounting, which if I understand correctly
happens long after system_state gets set to SYSTEM_RUNNING.

If RCU has some way to find out when init is complete, I can easily
make it so that CONFIG_RCU_FAST_NO_HZ optimizes for speed during boot
and energy efficiency during runtime.

One thing I could easily do would be to provide a sysfs parameter or
some such that allows the boot process to enable energy-efficiency
mode at runtime.  I would much prefer to make this automatic, though.

Other thoughts?

							Thanx, Paul

> Pascal
> 
> 
> > Message du 05/04/12 16:01
> > De : "Paul E. McKenney" 
> > A : "Josh Boyer" 
> > Copie à : linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org, pascal.chapperon@wanadoo.fr
> > Objet : Re: RCU related performance regression in 3.3
> > 
> > On Thu, Apr 05, 2012 at 08:37:59AM -0400, Josh Boyer wrote:
> > > On Wed, Apr 04, 2012 at 02:36:33PM -0700, Paul E. McKenney wrote:
> > > > On Wed, Apr 04, 2012 at 11:27:27AM -0400, Josh Boyer wrote:
> > > > > Hi Paul,
> > > > > 
> > > > > We've had a few reports of some boot slowdowns with the 3.3 rebase we
> > > > > did in Fedora 16. One of our users volunteered to bisect a vanilla
> > > > > kernel and wound up at "rcu: Permit dyntick-idle with callbacks pending
> > > > > (commit 7cb924990)". You can find more details in the bug [1], but it's
> > > > > been reported on both physical hardware and in virtual machines.
> > > > > 
> > > > > Have you seen anything like this in your testing? Given the user used a
> > > > > vanilla 3.3 kernel, I'm wondering if there is a targetted fix that might
> > > > > be backported. If so, it would be good to get that headed to the 3.3.y
> > > > > stable tree.
> > > > > 
> > > > > josh
> > > > > 
> > > > > [1] https://bugzilla.redhat.com/show_bug.cgi?id=806548
> > > > 
> > > > I will look into this. In the meantime, does setting
> > > > CONFIG_RCU_FAST_NO_HZ=n get rid of the slowdowns?
> > > 
> > > Seems so. Pascal tried 3.4-rc1 with and without that set and found that
> > > disabling it lead to consistent timings. He put his findings in the
> > > bug, and I've also now CC'd him.
> > 
> > Thank you for the info! Is the performance problem limited to boot time,
> > or are there performance problems when the system is up and running?
> > 
> > Thanx, Paul
> > 
> >
> 

