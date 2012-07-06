Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2GFGia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:38:30 -0400
Received: from mail.vyatta.com ([76.74.103.46]:38378 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab2GFGi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:38:28 -0400
Date: Thu, 5 Jul 2012 23:38:16 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, mashirle@us.ibm.com, kvm@vger.kernel.org,
        mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        sri@us.ibm.com
Subject: Re: [net-next RFC V5 5/5] virtio_net: support negotiating the
 number of queues through ctrl vq
Message-ID: <20120705233816.3ec0b827@nehalam.linuxnetplumber.net>
In-Reply-To: <4FF65966.9040600@redhat.com>
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
	<1341484194-8108-6-git-send-email-jasowang@redhat.com>
	<1341492679.18786.18.camel@lappy>
	<4FF65966.9040600@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jul 2012 11:20:06 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 07/05/2012 08:51 PM, Sasha Levin wrote:
> > On Thu, 2012-07-05 at 18:29 +0800, Jason Wang wrote:
> >> @@ -1387,6 +1404,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> >>          if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> >>                  vi->has_cvq = true;
> >>
> >> +       /* Use single tx/rx queue pair as default */
> >> +       vi->num_queue_pairs = 1;
> >> +       vi->total_queue_pairs = num_queue_pairs;
> > The code is using this "default" even if the amount of queue pairs it
> > wants was specified during initialization. This basically limits any
> > device to use 1 pair when starting up.
> >
> 
> Yes, currently the virtio-net driver would use 1 txq/txq by default 
> since multiqueue may not outperform in all kinds of workload. So it's 
> better to keep it as default and let user enable multiqueue by ethtool -L.
> 

I would prefer that the driver sized number of queues based on number
of online CPU's. That is what real hardware does. What kind of workload
are you doing? If it is some DBMS benchmark then maybe the issue is that
some CPU's need to be reserved.
