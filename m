Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab2J3PuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:50:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2J3PuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:50:16 -0400
Date: Tue, 30 Oct 2012 08:50:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 05/12] VMCI: event handling implementation.
Message-ID: <20121030155012.GE14167@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010420.17788.59187.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030022446.GF1920@kroah.com>
 <20121030045821.GD32055@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030045821.GD32055@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 09:58:21PM -0700, Dmitry Torokhov wrote:
> On Mon, Oct 29, 2012 at 07:24:46PM -0700, Greg KH wrote:
> > On Mon, Oct 29, 2012 at 06:04:27PM -0700, George Zhang wrote:
> > > +/*
> > > + * Releases the given VMCISubscription.
> > > + * Fires the destroy event if the reference count has gone to zero.
> > > + */
> > > +static void event_release(struct vmci_subscription *entry)
> > > +{
> > > +	kref_put(&entry->kref, event_signal_destroy);
> > > +}
> > 
> > Same question as before with the kref_put() call, what is handling the
> > locking here?  It looks like a race to me.
> 
> The reference is taken only if event is on the list (which managed by
> RCU and a mutex), so it is not possible to go from 0->1 for that
> refcount.

Ok, as long as you have audited this.

greg k-h
