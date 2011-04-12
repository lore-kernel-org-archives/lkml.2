Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1DLUoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:44:03 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50565 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757261Ab1DLUoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:44:00 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1302640226.2661.34.camel@dolmen>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <1302584571.2558.24.camel@mulgrave.site>  <1302597737.2661.5.camel@dolmen>
	 <1302615745.2604.6.camel@mulgrave.site>  <1302617212.2661.14.camel@dolmen>
	 <1302621261.2604.18.camel@mulgrave.site>  <1302624266.2661.21.camel@dolmen>
	 <1302625621.2604.24.camel@mulgrave.site>  <1302627097.2661.25.camel@dolmen>
	 <1302630090.2604.30.camel@mulgrave.site>  <1302633208.2661.29.camel@dolmen>
	 <1302638216.2604.35.camel@mulgrave.site>  <1302640226.2661.34.camel@dolmen>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 15:43:56 -0500
Message-ID: <1302641036.2604.40.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 21:30 +0100, Steven Whitehouse wrote:
> > Hmm, wrong signal for no elevator then.  How about this?
> > 
> > James
> > 
> That seems to do the trick... the box has been booted for several
> minutes now and no sign of anything untoward so far :-)
> 
> Below is the cumulative patch which I now have applied to the kernel.
> Many thanks for all your help in debugging this, its greatly
> appreciated :-)

Heh, you're welcome, but this is for some value of debug.  There's still
something strange going on on your box causing extreme delays in the way
we do stuff.  I took advantage of the delays to explore some races in
block and SCSI, which is what got fixed .. I've still no idea what the
actual root cause of the delays is.

Now we need to huddle and decide what we're doing in block and SCSI.  I
think Tejun's patch with the moved signal for queue destruction patch
would probably work as well.

James


