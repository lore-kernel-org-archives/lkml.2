Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2BJSOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:14:17 -0500
Received: from tango.0pointer.de ([85.214.72.216]:43053 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2BJSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:14:16 -0500
Date: Fri, 10 Feb 2012 19:14:14 +0100
From: Lennart Poettering <mzerqung@0pointer.de>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, selinux@lists.fedoraproject.org,
        initramfs@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Harald Hoyer <harald@redhat.com>
Subject: Re: [systemd-devel] dracut: ordering of modules
Message-ID: <20120210181413.GA13111@tango.0pointer.de>
References: <1328886121.2472.19.camel@falcor>
 <4F353840.8050505@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F353840.8050505@polito.it>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10.02.12 16:31, Roberto Sassu (roberto.sassu@polito.it) wrote:

> 
> Hi Mimi
> 
> i'm CCing the systemd and Fedora SELinux mailing lists.
> 
> Unfortunately, the SELinux policy initialization (at least
> in Fedora 16) has been moved to systemd, so, now, loading an
> IMA policy cannot be done in the initial ramdisk.
> 
> Further, the SELinux policy loading code is not in a unit file
> but embedded in the main binary, which means that the new code for
> loading IMA policies must be added just after that point.
> 
> I already wrote a patch for this. I need some time to test it
> and will post in the systemd mailing list at the beginning of
> the next week.

Hmm, what is this about? You need a place to load additional security
policies into the kernel at early boot? For SELinux that indeed takes
place from within PID 1 now in systemd. I'd expect that other security
technologies like AppArmor should work the same.

If you want to hack on this basing your work on selinux-setup.c in the
systemd tree should be fairly easy.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
