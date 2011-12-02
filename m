Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1LBBLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:11:05 -0500
Received: from ozlabs.org ([203.10.76.45]:52873 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab1LBBK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] virtio-scsi: first version
In-Reply-To: <4ED73CA3.5080409@redhat.com>
References: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>  <1322661299-28855-2-git-send-email-pbonzini@redhat.com> <1322721200.3651.24.camel@lappy> <4ED73CA3.5080409@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 02 Dec 2011 10:59:42 +1030
Message-ID: <8739d3stmx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Dec 2011 09:36:51 +0100, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 12/01/2011 07:33 AM, Sasha Levin wrote:
> > On Wed, 2011-11-30 at 14:54 +0100, Paolo Bonzini wrote:
> >> +	/* We need to know how many segments before we allocate.
> >> +         * We need an extra sg elements at head and tail.
> >> +	 */
> >> +	sg_elems = virtscsi_config_get(vdev, seg_max);
> >
> > Maybe default to one if not specified (=0), like in virtio-blk.
> 
> Good idea.  Though with sg_elems=1 it is insanely slow.

And a bit over-conservative.  If they don't specify a max, you can pick
a number.  Make sure it fits in the ring though :)

Thanks,
Rusty.
