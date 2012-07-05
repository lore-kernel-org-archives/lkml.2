Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2GEMu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:50:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47414 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab2GEMue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:50:34 -0400
Message-ID: <1341492679.18786.18.camel@lappy>
Subject: Re: [net-next RFC V5 5/5] virtio_net: support negotiating the
 number of queues through ctrl vq
From: Sasha Levin <levinsasha928@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Date: Thu, 05 Jul 2012 14:51:19 +0200
In-Reply-To: <1341484194-8108-6-git-send-email-jasowang@redhat.com>
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
	 <1341484194-8108-6-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 18:29 +0800, Jason Wang wrote:
> @@ -1387,6 +1404,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>                 vi->has_cvq = true;
>  
> +       /* Use single tx/rx queue pair as default */
> +       vi->num_queue_pairs = 1;
> +       vi->total_queue_pairs = num_queue_pairs; 

The code is using this "default" even if the amount of queue pairs it
wants was specified during initialization. This basically limits any
device to use 1 pair when starting up.

