Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030699Ab2COPBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:01:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40969 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030379Ab2COPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:00:59 -0400
Date: Thu, 15 Mar 2012 08:00:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120315150054.GD7928@kroah.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
 <4F611991.9040604@redhat.com>
 <20120314233225.GA16564@kroah.com>
 <4F61525D.2080404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F61525D.2080404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:22:21PM -0300, Mauro Carvalho Chehab wrote:
> Em 14-03-2012 20:32, Greg KH escreveu:
> > On Wed, Mar 14, 2012 at 07:20:01PM -0300, Mauro Carvalho Chehab wrote:
> >>> Easy rule to remember, never mix "raw" kobjects and 'struct device',
> >>> which is what you would be doing here, right?  We can handle many
> >>> hundreds of thousands of files and devices in a single directory, no
> >>> problem.
> >>
> >> No. They're all generated with raw kobjects, using kobject_init_and_add() or
> >> sysfs_create_file() calls.
> > 
> > Ick, no.
> > 
> > Please, never use "raw" kobjects.  Why doesn't 'struct device' work for
> > you properly here?  You just messed userspace all up in that it can not
> > properly account for the parts of sysfs here in the device tree.
> > 
> > Anything below /sys/devices/ should be using 'struct device' unless
> > there is a _very_ good reason not to.
> 
> The raw kobjects logic is there since the beginning of the edac. I've no
> idea why.

Probably because 'struct sysdev' was what /sys/devices/system/ used to
have, and it wasn't the easiest thing to work with.

I'd recommend converting the whole thing to struct device, if you are
going to be doing any work to this code.  I had figured this code was
not really needed anymore, but you've proved that wrong :)

good luck,

greg k-h
