Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2BLAUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 19:20:33 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46662 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2BLAUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 19:20:32 -0500
Subject: Re: [systemd-devel] dracut: ordering of modules
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Lennart Poettering <mzerqung@0pointer.de>
Cc: Roberto Sassu <roberto.sassu@polito.it>, selinux@lists.fedoraproject.org,
        initramfs@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Harald Hoyer <harald@redhat.com>
Date: Sat, 11 Feb 2012 19:17:25 -0500
In-Reply-To: <20120210181413.GA13111@tango.0pointer.de>
References: <1328886121.2472.19.camel@falcor> <4F353840.8050505@polito.it>
	 <20120210181413.GA13111@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1329005846.4201.39.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021200-3352-0000-0000-0000028F8823
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 19:14 +0100, Lennart Poettering wrote:
> On Fri, 10.02.12 16:31, Roberto Sassu (roberto.sassu@polito.it) wrote:
> 
> > 
> > Hi Mimi
> > 
> > i'm CCing the systemd and Fedora SELinux mailing lists.
> > 
> > Unfortunately, the SELinux policy initialization (at least
> > in Fedora 16) has been moved to systemd, so, now, loading an
> > IMA policy cannot be done in the initial ramdisk.
> > 
> > Further, the SELinux policy loading code is not in a unit file
> > but embedded in the main binary, which means that the new code for
> > loading IMA policies must be added just after that point.
> > 
> > I already wrote a patch for this. I need some time to test it
> > and will post in the systemd mailing list at the beginning of
> > the next week.

Thanks Roberto!
 
> Hmm, what is this about? You need a place to load additional security
> policies into the kernel at early boot? For SELinux that indeed takes
> place from within PID 1 now in systemd. I'd expect that other security
> technologies like AppArmor should work the same.

The IMA measurement/appraisal policy, which is described in
Documentation/ABI/testing/ima_policy, can be based on a number
of criteria.  One of these criteria are LSM subj/obj labels. The IMA
measurement/appraisal policy should be loaded as early as possible, but
only after the LSM policy has been loaded.

Mimi

> If you want to hack on this basing your work on selinux-setup.c in the
> systemd tree should be fairly easy.
> 
> Lennart

