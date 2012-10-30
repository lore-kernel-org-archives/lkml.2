Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab2J3P7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:59:41 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:54205 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350Ab2J3P7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:59:40 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 05/12] VMCI: event handling implementation.
Date: Tue, 30 Oct 2012 08:59:39 -0700
Message-ID: <2950075.FZEQUln4vx@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121030155041.GF14167@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com> <20121030050152.GE32055@dtor-ws.eng.vmware.com> <20121030155041.GF14167@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2012 08:50:41 AM Greg KH wrote:
> On Mon, Oct 29, 2012 at 10:01:52PM -0700, Dmitry Torokhov wrote:
> > On Mon, Oct 29, 2012 at 07:26:05PM -0700, Greg KH wrote:
> > > On Mon, Oct 29, 2012 at 06:04:27PM -0700, George Zhang wrote:
> > > > +static void event_signal_destroy(struct kref *kref)
> > > > +{
> > > > +	struct vmci_subscription *entry =
> > > > +			container_of(kref, struct vmci_subscription, kref);
> > > > +
> > > > +	complete(&entry->done);
> > > > +}
> > > 
> > > Didn't you just leak memory here?  What frees the structure up?
> > 
> > event_unregister_subscription() waits for that completion and frees the
> > structure. We want event_unregister_subscription() to wait until all
> > fired callbacks completed before unregister is complete.
> 
> So all calls to this can just sit and spin waiting for others to clean
> up?  Odd, but ok.

Not all as there is logically only one owner of the subscription so
naturally it waits until all notification callbacks are done.

Frankly we have a change that gets rid of delayed ecvent callbacks
and so the refcounting is no longer needed at all.

Thanks,
Dmitry

