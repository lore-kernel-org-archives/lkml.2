Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1C1RsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab1C1RsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:48:15 -0400
Date: Mon, 28 Mar 2011 18:48:11 +0100
From: Steven Hardy <shardy@redhat.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: gregkh@suse.de, mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] Fix memory leak in qcserial driver
Message-ID: <20110328174811.GD7030@shardy.csb>
References: <1301321186.4397.13.camel@shardy.csb>
 <20110328173422.GA6354@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328173422.GA6354@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 01:34:24PM -0400, Aristeu Rozanski wrote:
> > +	usb_set_serial_data(serial, data);
> >  	return retval;
> >  }
> when there's a -ENODEV, kfree() is called but the now invalid address is
> set by usb_set_serial_data() anyway. am I missing something here?

The intention here is that since data should be NULL after the kfree, we're simply setting serial->private to NULL.

I can add a conditional to avoid calling usb_set_serial_data() for -ENODEV if it's deemed cleaner or more readable.

Thanks for the comments,

Steve
