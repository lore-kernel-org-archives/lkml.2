Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2JIQmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:42:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49505 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2JIQmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:42:17 -0400
Date: Tue, 9 Oct 2012 12:30:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] xen-blkfront: handle backend CLOSED without CLOSING
Message-ID: <20121009163023.GG31499@phenom.dumpdata.com>
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
 <1348243464-15903-3-git-send-email-david.vrabel@citrix.com>
 <5061EFB2.1080407@citrix.com>
 <5069D097.60606@citrix.com>
 <20121002200255.GA668@phenom.dumpdata.com>
 <506EC79D.5080206@citrix.com>
 <506EE6CD020000780009FF4E@nat28.tlf.novell.com>
 <506F0370.6050905@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506F0370.6050905@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 04:57:36PM +0100, David Vrabel wrote:
> On 05/10/12 12:55, Jan Beulich wrote:
> >>>> On 05.10.12 at 13:42, David Vrabel <david.vrabel@citrix.com> wrote:
> >> On 02/10/12 21:02, Konrad Rzeszutek Wilk wrote:
> >>> On Mon, Oct 01, 2012 at 06:19:19PM +0100, David Vrabel wrote:
> >>>> On 25/09/12 18:53, David Vrabel wrote:
> >>>>> On 21/09/12 17:04, David Vrabel wrote:
> >>>>>> From: David Vrabel <david.vrabel@citrix.com>
> >>>>>>
> >>>>>> Backend drivers shouldn't transistion to CLOSED unless the frontend is
> >>>>>> CLOSED.  If a backend does transition to CLOSED too soon then the
> >>>>>> frontend may not see the CLOSING state and will not properly shutdown.
> >>>>>>
> >>>>>> So, treat an unexpected backend CLOSED state the same as CLOSING.
> >>>>>
> >>>>> Didn't handle the frontend block device being mounted. Updated patch here.
> >>>>
> >>>> Konrad, can you ack this updated patch if you're happy with it.
> >>>
> >>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>>
> >>> Or should I just carry it in my for-jens-3.7 bug-fixes queue and ask
> >>> Jen to pull it once rc0 is out?
> >>
> >> This seems easiest, if Jan is happy with the patch.
> > 
> > I see the point of your explanation yesterday, but am still not
> > convinced that the early cleanup in spite of active users of the
> > disk can't cause any problems (like dangling pointers or NULL
> > dereferences).
> 
> I tested it some more and it is broken.  Please apply the first version
> instead.

OK, can we do this once more - can you repost the patches, but CC the
invidiual maintainers? The FB and KBD need to go through Florian I think?

> 
> blkfront needs to cancel and complete with an error requests that are
> are still on the ring after the backend has disconnected and it needs to
> complete with an error all requests submitted while disconnected.
> Otherwise, if there is outstanding requests or new requests then
> del_gendisk() blocks waiting for the I/O to complete.
> 
> David
