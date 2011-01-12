Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1ALLi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:38:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:45371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1ALLiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:38:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,312,1291622400"; 
   d="scan'208";a="592171910"
Date: Wed, 12 Jan 2011 11:14:01 +0000
From: Alan Cox <alan@linux.intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH] console: prevent registered consoles from dumping old
 kernel message over again
Message-ID: <20110112111401.4879d928@bob.linux.org.uk>
In-Reply-To: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
References: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 14:48:46 +0800
Feng Tang <feng.tang@intel.com> wrote:

> For a platform with many consoles like:
>  "console=tty1 console=ttyMFD2 console=ttyS0 earlyprintk=mrst"
> 
> Each time when the non "selected_console" (tty1 and ttyMFD2 here) get
> registered, the existing kernel message will be printed out on
> registered consoles again, the "mrst" early console will get some
> same message for 3 times, and "tty1" will get some for twice.
> 
> So try to temporarily disable registered console's printing when dump
> the existing kernel messages to the new console.

I don't think the existing behaviour should be changed because other
systems and users rely on it. Perhaps we need to be able to do

console=xxx addconsole=yyy

or some such instead so the user can indicate if the console should get
all the messages so far or just be added as an extra console 
