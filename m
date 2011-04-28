Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab1D1O7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:59:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:26694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882Ab1D1O7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:59:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,281,1301900400"; 
   d="scan'208";a="685362433"
Date: Thu, 28 Apr 2011 15:43:44 +0100
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: "Weil, Oren jer" <oren.jer.weil@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@woodhou.se" <david@woodhou.se>
Subject: Re: [PATCH 6/8] staging/mei: Header file contain the Userland API,
 (IOCTL and its struct)
Message-ID: <20110428154344.7af7cb1b@bob.linux.org.uk>
In-Reply-To: <20110428134036.GC4861@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
	<1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
	<20110427081541.80cc591a.randy.dunlap@oracle.com>
	<20110427153335.GA25973@suse.de>
	<F28B59AD52D84B479DCA469824475335065AF92F69@hasmsx503.ger.corp.intel.com>
	<20110428134036.GC4861@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Was this discussed in public?

Not much yet - but this is a staging driver so there is no defined ABI
and nothing is set in stone.

> > if someone has a good solution for that we are happy to hear it.
> 
> Did you rule out sysfs, configfs, netlink, etc.?

Pretty much. You need to create a handle, connect it to something and
perform transactions on it. Some of those must be serialized and they
have both input and output data, so they don't fit sysfs and friends.

It's effectively mostly a message passing system - the closest other
interface is the socket one but it doesn't really fit that and I don't
think Dave wants 'its got a connect sort of op so lets make it a socket
family' to be the device norm !

The identifier for the object is also long so doesn't work for a set of
devices by minor number either.

I think the more useful step is going to be some example user space as
that above all will show how it is intended to work

Alan
