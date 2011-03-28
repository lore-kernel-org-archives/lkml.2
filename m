Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1C1Ryw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab1C1Ryv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:54:51 -0400
Date: Mon, 28 Mar 2011 13:54:48 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Steven Hardy <shardy@redhat.com>
Cc: gregkh@suse.de, mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] Fix memory leak in qcserial driver
Message-ID: <20110328175448.GR2526@redhat.com>
References: <1301321186.4397.13.camel@shardy.csb>
 <20110328173422.GA6354@redhat.com>
 <20110328174811.GD7030@shardy.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328174811.GD7030@shardy.csb>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 06:48:11PM +0100, Steven Hardy wrote:
> On Mon, Mar 28, 2011 at 01:34:24PM -0400, Aristeu Rozanski wrote:
> > > +	usb_set_serial_data(serial, data);
> > >  	return retval;
> > >  }
> > when there's a -ENODEV, kfree() is called but the now invalid address is
> > set by usb_set_serial_data() anyway. am I missing something here?
> 
> The intention here is that since data should be NULL after the kfree, we're simply setting serial->private to NULL.
kfree(data) won't make data == NULL. it'll free whatever address data
has. data will still have the same (now stale) address. you need to
explicitely make data = NULL if you want that behavior.

-- 
Aristeu

