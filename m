Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031181Ab2CNXce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:32:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47088 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710Ab2CNXca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:32:30 -0400
Date: Wed, 14 Mar 2012 16:32:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120314233225.GA16564@kroah.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
 <20120314204355.GA10187@kroah.com>
 <4F611991.9040604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F611991.9040604@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 07:20:01PM -0300, Mauro Carvalho Chehab wrote:
> > Easy rule to remember, never mix "raw" kobjects and 'struct device',
> > which is what you would be doing here, right?  We can handle many
> > hundreds of thousands of files and devices in a single directory, no
> > problem.
> 
> No. They're all generated with raw kobjects, using kobject_init_and_add() or
> sysfs_create_file() calls.

Ick, no.

Please, never use "raw" kobjects.  Why doesn't 'struct device' work for
you properly here?  You just messed userspace all up in that it can not
properly account for the parts of sysfs here in the device tree.

Anything below /sys/devices/ should be using 'struct device' unless
there is a _very_ good reason not to.

thanks,

greg k-h
