Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1GBRJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 13:09:31 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50943 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866Ab1GBRJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 13:09:30 -0400
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, rjw@sisk.pl, linux-usb@vger.kernel.org
In-Reply-To: <20110702170554.GJ23059@one.firstfloor.org>
References: <1309554818.2722.48.camel@mulgrave>
	 <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
	 <20110702060846.GH23059@one.firstfloor.org>
	 <1309609482.2554.8.camel@mulgrave>
	 <20110702170554.GJ23059@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jul 2011 12:09:26 -0500
Message-ID: <1309626567.2554.11.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 19:05 +0200, Andi Kleen wrote:
> > Which goes from the device unplug to the oops.  However, there are puts
> > missing from this; particularly the one where the reference goes to
> > zero.
> 
> The count was always one off because it dumps it before the actual
> put.

I know this.  What I mean is the last seen put count before the oops is
3 (not 1).

And the transition after unplug goes

13->12->10->8->7->6->5->3

implying we're missing put events.

James


