Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1F3QXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:23:46 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42866 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab1F3QXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:23:42 -0400
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
Date: Thu, 30 Jun 2011 09:05:22 -0700
Message-ID: <1309449922.4561.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 12:13 +0300, Michael S. Tsirkin wrote:
> Assuming you mean vhost_zerocopy_signal_used, here's how I would do
> it:
> add a kref and a completion, signal completion in kref_put
> callback, when backend is set - kref_get, on cleanup,
> kref_put and then wait_for_completion_interruptible.
> Where's the need for another thread coming from?
> 
> If you like, post a patch with busywait + a FIXME comment,
> and I can write up a patch on top.
> 
> (BTW, ideally the function that does the signalling should be
> in core networking bits so that it's still around
> even if the vhost module gets removed). 

OK, I will modify the patch.

Thanks
Shirley

