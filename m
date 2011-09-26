Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1IZT47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab1IZT46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:56:58 -0400
Date: Mon, 26 Sep 2011 22:57:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] virtio-net: Verify page list size before fitting
 into skb
Message-ID: <20110926195716.GB23086@redhat.com>
References: <1317058869-19276-1-git-send-email-levinsasha928@gmail.com>
 <20110926184445.GA22278@redhat.com>
 <1317065842.20885.3.camel@lappy>
 <CAOJsxLHQZCvRQMcs08GZgDgR9AwtePdr=t7kos6XfMF_dgxZGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLHQZCvRQMcs08GZgDgR9AwtePdr=t7kos6XfMF_dgxZGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:45:35PM +0300, Pekka Enberg wrote:
> On Mon, Sep 26, 2011 at 10:37 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> >> Interesting.  This is a theoretical issue, correct?
> >> Not a crash you actually see.
> >
> > Actually it was an actual crash caused when our virtio-net driver in kvm
> > tools did funny things and passed '(u32)-1' length as a buffer length to
> > the guest kernel.
> 
> I'm not sure what Michael means with "theoretical issue" here. Can the guest
> driver assume that the hypervisor doesn't attempt to do nasty things?
> 
>                           Pekka

IMO yes, hypervisor has full access to guest memory so it's a safe
assumption. But surviving in the face of hypervisor bugs
is laudable goal, bugs do happen.

-- 
MST
