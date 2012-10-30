Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2J3FBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 01:01:53 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37777 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715Ab2J3FBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 01:01:52 -0400
Date: Mon, 29 Oct 2012 22:01:52 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 05/12] VMCI: event handling implementation.
Message-ID: <20121030050152.GE32055@dtor-ws.eng.vmware.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010420.17788.59187.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030022605.GG1920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030022605.GG1920@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 07:26:05PM -0700, Greg KH wrote:
> On Mon, Oct 29, 2012 at 06:04:27PM -0700, George Zhang wrote:
> > +static void event_signal_destroy(struct kref *kref)
> > +{
> > +	struct vmci_subscription *entry =
> > +			container_of(kref, struct vmci_subscription, kref);
> > +
> > +	complete(&entry->done);
> > +}
> 
> Didn't you just leak memory here?  What frees the structure up?

event_unregister_subscription() waits for that completion and frees the
structure. We want event_unregister_subscription() to wait until all
fired callbacks completed before unregister is complete.

Thanks,
Dmitry
