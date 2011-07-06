Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1GFT21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:28:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39784 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab1GFT2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:28:25 -0400
Subject: Re: [PATCH V7 4/4 net-next] vhost: vhost TX zero-copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110629091300.GC14627@redhat.com>
References: <1306611267.5180.97.camel@localhost.localdomain>
	 <20110629091300.GC14627@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 12:28:16 -0700
Message-ID: <1309980496.10209.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 12:13 +0300, Michael S. Tsirkin wrote:
> On Sat, May 28, 2011 at 12:34:27PM -0700, Shirley Ma wrote:
> > Hello Michael,
> > 
> > In order to use wait for completion in shutting down, seems to me
> > another work thread is needed to call vhost_zerocopy_add_used,
> 
> Hmm I don't see vhost_zerocopy_add_used here.

I put the call in vhost_set_vring.

> 
> > it seems
> > too much work to address a minor issue here. Do we really need it?
> 
> Assuming you mean vhost_zerocopy_signal_used, here's how I would do
> it:
> add a kref and a completion, signal completion in kref_put
> callback, when backend is set - kref_get, on cleanup,
> kref_put and then wait_for_completion_interruptible.
> Where's the need for another thread coming from?
> 
> If you like, post a patch with busywait + a FIXME comment,
> and I can write up a patch on top.

I might not have time  to finish this during my vacation, so I am
putting busywait + a FIXME comment.

> (BTW, ideally the function that does the signalling should be
> in core networking bits so that it's still around
> even if the vhost module gets removed). 

Thanks
Shirley

