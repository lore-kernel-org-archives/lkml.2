Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1ALOvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:51:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:57751 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1ALOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:51:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,313,1291622400"; 
   d="scan'208";a="696041195"
Date: Wed, 12 Jan 2011 22:51:14 +0800
From: Feng Tang <feng.tang@intel.com>
To: Alan Cox <alan@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] console: prevent registered consoles from dumping old
 kernel message over again
Message-ID: <20110112225114.37d3b984@feng-i7>
In-Reply-To: <20110112111401.4879d928@bob.linux.org.uk>
References: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
	<20110112111401.4879d928@bob.linux.org.uk>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, 12 Jan 2011 19:14:01 +0800
Alan Cox <alan@linux.intel.com> wrote:

> On Wed, 12 Jan 2011 14:48:46 +0800
> Feng Tang <feng.tang@intel.com> wrote:
> 
> > For a platform with many consoles like:
> >  "console=tty1 console=ttyMFD2 console=ttyS0 earlyprintk=mrst"
> > 
> > Each time when the non "selected_console" (tty1 and ttyMFD2 here)
> > get registered, the existing kernel message will be printed out on
> > registered consoles again, the "mrst" early console will get some
> > same message for 3 times, and "tty1" will get some for twice.
> > 
> > So try to temporarily disable registered console's printing when
> > dump the existing kernel messages to the new console.
> 
> I don't think the existing behaviour should be changed because other
> systems and users rely on it. Perhaps we need to be able to do
> 
> console=xxx addconsole=yyy
> 
> or some such instead so the user can indicate if the console should
> get all the messages so far or just be added as an extra console 


Don't know if I understand correctly, but with this patch all the consoles
still will get the full version of kernel messages, it just save some
console from dumping some of the early messages several times.

Still use the old example, assume log0 is the kernel messages from boot start to
the point where tty1 get registered, log1 is from tty1's registering to
ttyMFD2's, log2 is the rest kernel message. Before this patch, on the
boot console, we will see: log0 + log0 + log1 + log0 + log1 + log2.

Thanks,
Feng
