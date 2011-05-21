Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1EUCek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 22:34:40 -0400
Received: from ozlabs.org ([203.10.76.45]:37216 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1EUCeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 22:34:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: Re: [PATCHv2 06/14] virtio: add api for delayed callbacks
In-Reply-To: <8f343dcaa996f6b10499468c49508ba9d6fb6f5a.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com> <8f343dcaa996f6b10499468c49508ba9d6fb6f5a.1305846412.git.mst@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sat, 21 May 2011 12:03:35 +0930
Message-ID: <87mxigu6io.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 02:11:14 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Add an API that tells the other side that callbacks
> should be delayed until a lot of work has been done.
> Implement using the new event_idx feature.
> 
> Note: it might seem advantageous to let the drivers
> ask for a callback after a specific capacity has
> been reached. However, as a single head can
> free many entries in the descriptor table,
> we don't really have a clue about capacity
> until get_buf is called. The API is the simplest
> to implement at the moment, we'll see what kind of
> hints drivers can pass when there's more than one
> user of the feature.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Yes, I've applied this (and the next one which uses it in virtio_net),
despite my reservations about the API.  But that is fixable...

Thanks,
Rusty.
