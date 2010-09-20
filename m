Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0ITJRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:17:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:13239 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab0ITJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:17:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,392,1280732400"; 
   d="scan'208";a="659050468"
Date: Mon, 20 Sep 2010 09:31:07 +0100
From: Alan Cox <alan@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
        drosenberg@vsecurity.com
Subject: Re: [PATCH 0/3] Fix the TIOCGICOUNT problem for good
Message-ID: <20100920093107.379c431c@linux.intel.com>
In-Reply-To: <20100918155820.GA3942@infradead.org>
References: <20100916171747.25987.33573.stgit@localhost.localdomain>
	<20100918155820.GA3942@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010 11:58:20 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Sep 16, 2010 at 06:21:06PM +0100, Alan Cox wrote:
> > Remembering to clear fields is something driver authors are simply
> > never going to remember to get right every new driver. Instead take
> > the problem away from them and give them a simple interface to do
> > the job.
> 
> Btw, I wonder if all the standard tty ioctls should get similar
> treatment.  That way we have a nice enough skeleton of what needs to
> be implemented in every tty driver instead of passing down the raw
> ioctl method.

They have pretty much entirely now - TIOCMIWAIT is the main one that
hasn't been done, but that really wants a generic implementation in
tty_port that most drivers could then use.

Alan
