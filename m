Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2KZPO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:14:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab2KZPO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:14:27 -0500
Subject: Re: [ 64/66] GFS2: Test bufdata with buffer locked and
 gfs2_log_lock held
From: Steven Whitehouse <swhiteho@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <1353849115.4424.6.camel@deadeye.wl.decadent.org.uk>
References: <20121115040939.016421011@linuxfoundation.org>
	 <20121115040943.748338602@linuxfoundation.org>
	 <1353849115.4424.6.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 26 Nov 2012 15:13:21 +0000
Message-ID: <1353942801.2716.18.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2012-11-25 at 14:11 +0100, Ben Hutchings wrote:
> On Wed, 2012-11-14 at 20:11 -0800, Greg Kroah-Hartman wrote:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > commit 96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489 upstream.
> > 
> > In gfs2_trans_add_bh(), gfs2 was testing if a there was a bd attached to the
> > buffer without having the gfs2_log_lock held. It was then assuming it would
> > stay attached for the rest of the function. However, without either the log
> > lock being held of the buffer locked, __gfs2_ail_flush() could detach bd at any
> > time.  This patch moves the locking before the test.  If there isn't a bd
> > already attached, gfs2 can safely allocate one and attach it before locking.
> > There is no way that the newly allocated bd could be on the ail list,
> > and thus no way for __gfs2_ail_flush() to detach it.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [...]
> 
> Is this needed for any earlier versions?  It looks applicable to 3.2
> (with minor changes).
> 
> Ben.
> 

Potentially yes, although I don't think we've had any reports from that
far back,

Steve.


