Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab2LDAWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:22:14 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:24354 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2LDAWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:22:12 -0500
Message-ID: <1354580527.2819.16.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [net-next rfc v7 3/3] virtio-net: change the number of queues
 through ethtool
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, <rusty@rustcorp.com.au>,
        <krkumar2@in.ibm.com>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <jwhan@filewood.snu.ac.kr>, <shiyer@redhat.com>
Date: Tue, 4 Dec 2012 00:22:07 +0000
In-Reply-To: <20121203112507.GE26167@redhat.com>
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com>
	 <1354011360-39479-4-git-send-email-jasowang@redhat.com>
	 <20121202160906.GB27761@redhat.com>
	 <7408756.Sj6HEpCzzZ@jason-thinkpad-t430s>
	 <20121203112507.GE26167@redhat.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 13:25 +0200, Michael S. Tsirkin wrote:
> On Mon, Dec 03, 2012 at 02:09:28PM +0800, Jason Wang wrote:
> > On Sunday, December 02, 2012 06:09:06 PM Michael S. Tsirkin wrote:
> > > On Tue, Nov 27, 2012 at 06:16:00PM +0800, Jason Wang wrote:
> > > > This patch implement the {set|get}_channels method of ethool to allow user
> > > > to change the number of queues dymaically when the device is running.
> > > > This would let the user to configure it on demand.
> > > > 
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > > 
> > > >  drivers/net/virtio_net.c |   41 +++++++++++++++++++++++++++++++++++++++++
> > > >  1 files changed, 41 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index bcaa6e5..f08ec2a 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -1578,10 +1578,51 @@ static struct virtio_driver virtio_net_driver = {
> > > > 
> > > >  #endif
> > > >  };
> > > > 
> > > > +/* TODO: Eliminate OOO packets during switching */
> > > > +static int virtnet_set_channels(struct net_device *dev,
> > > > +				struct ethtool_channels *channels)
> > > > +{
> > > > +	struct virtnet_info *vi = netdev_priv(dev);
> > > > +	u16 queue_pairs = channels->combined_count;
> 
> by the way shouldn't this be combined_count / 2?
> 
> And below channels->max_combined = vi->max_queue_pairs * 2; ?
[...]

In this ethtool API, 'channel' means an IRQ and set of queues that
trigger it.  So each ethtool-channel will correspond to one queue-pair
and not one virtio channel.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

