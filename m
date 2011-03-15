Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1COQdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:33:02 -0400
Received: from cantor.suse.de ([195.135.220.2]:47427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab1COQc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:32:59 -0400
Subject: Re: [Security] [PATCH 00/20] world-writable files in sysfs and
 debugfs
From: James Bottomley <James.Bottomley@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Greg KH <greg@kroah.com>, security@kernel.org,
        acpi4asus-user@lists.sourceforge.net, linux-scsi@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        open-iscsi@googlegroups.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
In-Reply-To: <20110315160804.GA3380@albatros>
References: <cover.1296818921.git.segoon@openwall.com>
	 <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
	 <1300155965.5665.15.camel@mulgrave.site> <20110315030956.GA2234@kroah.com>
	 <1300189828.4017.2.camel@mulgrave.site>  <20110315160804.GA3380@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 12:32:31 -0400
Message-ID: <1300206751.11313.3.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 19:08 +0300, Vasiliy Kulikov wrote:
> On Tue, Mar 15, 2011 at 07:50 -0400, James Bottomley wrote:
> >      1. Did anyone actually check for capabilities before assuming world
> >         writeable files were wrong?
> 
> I didn't check all these files as I haven't got these hardware :-)

You don't need the hardware to check ... the question becomes is a
capabilities test sitting in the implementation or not.

>   But
> as I can "chmod a+w" all sysfs files on my machine and they all become
> sensible to nonroot writes, I suppose there is nothing preventing
> nonroot users from writing to these buggy sysfs files.  As you can see,
> there are no capable() checks in these drivers in open() or write().
> 
> >      2. Even if there aren't any capabilities checks in the implementing
> >         routines, should there be (are we going the separated
> >         capabilities route vs the monolithic root route)?
> 
> IMO, In any case old good DAC security model must not be obsoleted just
> because someone thinks that MAC or anything else is more convenient for
> him.  If sysfs is implemented via filesystem then it must support POSIX
> permissions semantic.  MAC is very good in _some_ cases, but not instead
> of DAC.

Um, I'm not sure that's even an issue.  capabilities have CAP_ADMIN
which is precisely the same check as owner == root.  We use this a lot
because ioctls ignore the standard unix DAC model.

James



