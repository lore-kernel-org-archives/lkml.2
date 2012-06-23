Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2FWT0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 15:26:45 -0400
Received: from mail-yw0-f56.google.com ([209.85.213.56]:62502 "EHLO
	mail-yw0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab2FWT0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 15:26:42 -0400
X-Greylist: delayed 13196 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2012 15:26:42 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Sat, 23 Jun 2012 12:26:41 -0700 (PDT)
In-Reply-To: <fa.cm6Pl6ITE2qRnrdz/DXqaOSgExs@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=173.61.128.124;
 posting-account=Z8DeKgoAAADzzz7td48SCL1roPWBmWKh
NNTP-Posting-Host: 173.61.128.124
References: <fa.WTHIDfGYg3w7zn9rxlDshNfnPtI@ifi.uio.no> <fa.lxvUw3/2JBxq1zvQzI4sJk8pEOQ@ifi.uio.no>
 <fa.Fdbx7aeDSXKMF/2ajG0IUf0AAKs@ifi.uio.no> <fa.TAjdtaR/BMl+PZAWwtAit9BevAo@ifi.uio.no>
 <fa.cm6Pl6ITE2qRnrdz/DXqaOSgExs@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 173.61.128.124
MIME-Version: 1.0
Message-ID: <8dc680a1-4a03-462d-b381-bf5c1470aa7e@googlegroups.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
From: iseletsk@cloudlinux.com
To: fa.linux.kernel@googlegroups.com
Cc: Alex Lyashkov <umka@cloudlinux.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 22, 2012 3:43:23 PM UTC-4, Greg KH wrote:
> On Fri, Jun 22, 2012 at 12:22:22PM -0700, Greg KH wrote:
> > On Fri, Jun 22, 2012 at 07:51:42PM +0100, Matthew Garrett wrote:
> > > On Fri, Jun 22, 2012 at 11:43:59AM -0700, Greg KH wrote:
> > > 
> > > > Do you have a pointer to this code anywhere?  Lying about the license to
> > > > the kernel is a pretty blatent thing to do and I'd like to have some
> > > > people follow up on that issue.
> > > 
> > > http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/x86_64/RPMS/kmod-lve-2.6.18-408.el5.lve1.1.64.2-1.1-10.7.3.el5.x86_64.rpm 
> > > - there's no corresponding SRPM in 
> > > http://repo.cloudlinux.com/cloudlinux/5.8/updates-testing/SRPMS/ and 
> > > upstream apparently refuse to provide source. Alex Lyashkov (Cc:ed) is 
> > > listed as module author in the metadata.
> > 
> > Hm, and at least one reason it needs to be GPL is due to it using
> > symbols I created, no fun.
> > 
> > Alex, can you please provide the source code for this module?  Or is the
> > license that the code is saying it is, somehow incorrect?  If so, can
> > you please fix it?  If you can't do this, is there someone else I should
> > be contacting?
> 
> Also, I almost hate to ask this, but why in the world are you creating
> sysfs binary files?  I really don't think you should be doing this, as
> those are only for firmware and other "pass-through" things the kernel
> uses to have userspace talk directly to hardware.
> 
> Odds are you can remove these files, and use the "correct" user/kernel
> interface which will result in much better speed and handle things
> properly for you, instead of abusing this interface.
> 
> Unless you really are talking directly to hardware, in which case, I'm
> kind of interested to see what you are doing here, so the source code
> would be greatly appreciated.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Greg,

We do a "hack", which is not a pretty one, populating /sys with .htaccess files. This is really needed only by shared hosters, where one of the end users on the server, could be a hacker and could create symlinks that would later be followed by apache to read privileged information.
A better fix would be fixing the apache. Yet, surprisingly enough -- we control kernel on those servers -- but we don't control apache. So -- we tried to secure things for our customers in this particular way. Most likely we will through it out anyway.


