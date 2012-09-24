Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab2IXVup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 17:50:45 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:34129 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab2IXVun convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 17:50:43 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Date: Mon, 24 Sep 2012 23:50:01 +0200
Subject: RE: [PATCHv4] virtio_console: Add support for remoteproc serial
Thread-Topic: [PATCHv4] virtio_console: Add support for remoteproc serial
Thread-Index: Ac2afG5MLqos0bSKTn+O3xrJFAwO2AAFO8Aw
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BD79D728@EXDCVYMBSTM005.EQ1STM.local>
References: <1348489987-6768-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120924174523.GA14390@amit.redhat.com>
In-Reply-To: <20120924174523.GA14390@amit.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BPLs Fwi3 OA2N SI7T XaO4 ZgZT hDYn p2uk saGy yKxz 1zfx
 8tFN AGFJlQ== AGki6g== AGtARw==
 AGuYuA==;9;YQBtAGkAdAAuAHMAaABhAGgAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAYQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGwAaQBuAHUAcwAuAHcAYQBsAGwAZQBpAGoAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AcwB0AEAAcgBlAGQAaABhAHQALgBjAG8AbQA7AG8AaABhAGQAQAB3AGkAegBlAHIAeQAuAGMAbwBtADsAcgB1AHMAdAB5AEAAcgB1AHMAdABjAG8AcgBwAC4AYwBvAG0ALgBhAHUAOwBzAGoAdQByAGIAcgBlAG4AQABnAG0AYQBpAGwALgBjAG8AbQA7AHYAaQByAHQAdQBhAGwAaQB6AGEAdABpAG8AbgBAAGwAaQBzAHQAcwAuAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA=;Sosha1_v1;7;{DC49FAE8-D836-44D4-958B-41B435D5DD7B};cwBqAHUAcgAuAGIAcgBhAG4AZABlAGwAYQBuAGQAQABzAHQAZQByAGkAYwBzAHMAbwBuAC4AYwBvAG0A;Mon,
 24 Sep 2012 21:50:01
 GMT;UgBFADoAIABbAFAAQQBUAEMASAB2ADQAXQAgAHYAaQByAHQAaQBvAF8AYwBvAG4AcwBvAGwAZQA6ACAAQQBkAGQAIABzAHUAcABwAG8AcgB0ACAAZgBvAHIAIAByAGUAbQBvAHQAZQBwAHIAbwBjACAAcwBlAHIAaQBhAGwA
x-cr-puzzleid: {DC49FAE8-D836-44D4-958B-41B435D5DD7B}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

> I'm sorry for not being able to look at this earlier.

No worries. I'll try to respin and retest this patch by tomorrow.
If you by any chance could find time to review so could make it in time
for 3.7 it would be great :-)

> A general comment is to base this patchset on linux-next; we've been
> seeing more than usual activity for virtio_console this time around.
> I don't expect the conflicts to be big, though.

Sure, I'll based the next patch on linux-next.

...
> > This implementation reuses the existing virtio_console
> > implementation, and adds support for DMA allocation
> > of data buffers and disables use of tty console and
> > the virtio control queue.
> 
> Any specific reason to not use the control queue?  It's just another
> virtio-serial port; the only special thing about it being it's an
> internal channel between the device and driver.

Yes, as mention to Michael earlier. I use rproc_serial for talking
to a modem running in early boot phases, before the OS has started,
or when the modem is executing it's crash handler. In both these 
cases the modem run in a very limited execution environment, so
I want to keep the protocol and handling of the vqs as simple as
possible. Due to this I really don't want more than single pair
of vqs.

We also have very simple use-cases. The port is opened once
in the life-time of the modem, and only reopened after a
cold-start of the modem. So I should not get into any issues
with race conditions.

> If you're not going to implement any control commands, I guess you
> could conveniently not use the actual port, but keep it around, in
> case you find use for it later.  The advantage will be that older
> kernels will work without any updates on newer devices.

With the current usage pattern I have in mind, I'd rather add this
feature later when/if needed. We can always add a new feature bit
for this if we introduce the control channel later on.

...

> > +#define rproc_enabled IS_ENABLED(CONFIG_REMOTEPROC)
> 
> Since 'rproc_enabled' could be false, suggest using 'is_rproc_enabled'.

Ok, I'll change this.

...
> > @@ -109,6 +113,15 @@ struct port_buffer {
> >  	size_t len;
> >  	/* offset in the buf from which to consume data */
> >  	size_t offset;
> > +
> > +	/* DMA address of buffer */
> > +	dma_addr_t dma;
> > +
> > +	/* Device we got DMA memory from */
> > +	struct device *dev;
> > +
> > +	/* List of pending dma buffers to free */
> > +	struct list_head list;
> 
> Aha, nice.  One of the comments I had with the earlier versions (I
> just went through all the revisions) was that you weren't using the
> port_buffer struct, and instead modifying all alloc_buf() and
> free_buf() calls.  This is much more saner.

Yes, it was cleaner when I started using port_buffer more place.
And as mentioned below, I'll start using port buffer from
put_chars() as well, this will improve a few things.

> > +static DEFINE_SPINLOCK(list_lock);
> > +static LIST_HEAD(pending_free_list);
> 
> The names list_lock, pending_free_list are very generic in the file's
> context.  Please use more specific names.

Sure, I'll rename these.

> 
> > +
> >  static void free_buf(struct port_buffer *buf)
> >  {
> > -	kfree(buf->buf);
> > +	unsigned long flags;
> > +
> > +	if (!buf->dev) {
> > +		kfree(buf->buf);
> > +		goto freebuf;
> > +	}
> > +
> > +	BUG_ON(!rproc_enabled);
> > +
> > +	/* dma_free_coherent requires interrupts to be enabled */
> > +	if (rproc_enabled && !irqs_disabled()) {
> 
> You don't need to check for rproc_enabled here.

Actually I do need this check. The reason is that I am
exploiting gcc's ability to discard dead code. When I compile
for arch's that does not have DMA, this block is dead and will be
discarded. This way I avoid the link error for the missing
symbol dma_free_coherent(). But I can add a comment on this.

> Then, you can just invert the if condition (if (irqs_disabled()) and
> include the relevant block here.  This way, you can make do without
> the goto and return mess below.

Yeah, I did an earlier version without goto, but I wanted to separate
the rproc / non-rproc clearly to make it easier to see what happened
if rproc was disabled. But I'll have a stab at refactoring this code
again.

> > +		dma_free_coherent(buf->dev, buf->size, buf->buf, buf->dma);
> > +
> > +		/* Release device refcnt and allow it to be freed */
> > +		might_sleep();
> > +		put_device(buf->dev);
> > +		goto freebuf;
> > +	}
> > +

...
> > +		if (!vq->vdev->dev.parent || !vq->vdev->dev.parent->parent)
> > +			goto free_buf;
> > +		buf->dev = vq->vdev->dev.parent->parent;
> > +
> > +		/* Increase device refcnt to avoid freeing it*/
> > +		get_device(buf->dev);
> > +		buf->buf = dma_alloc_coherent(buf->dev, buf_size, &buf-
> >dma,
> > +						GFP_KERNEL);
> 
> incorrect indentation

OK, I'll fix this.

> > @@ -485,7 +582,10 @@ static void reclaim_consumed_buffers(struct port
> *port)
> >  		return;
> >  	}
> >  	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
> > -		kfree(buf);
> > +		if (is_console_port(port))
> > +			kfree(buf);
> > +		else
> > +			free_buf(buf);
> 
> Hm?

See below.

> 
> >  		port->outvq_full = false;
> >  	}
> >  }
> > @@ -498,6 +598,7 @@ static ssize_t send_buf(struct port *port, void
> *in_buf, size_t in_count,
> >  	ssize_t ret;
> >  	unsigned long flags;
> >  	unsigned int len;
> > +	struct port_buffer *buf = in_buf;
> 
> This looks wrong: the buffer we receive here is the actual data
> (buf->buf).  It can never be a port_buffer (buf).

See below.

> 
> >
> >  	out_vq = port->out_vq;
> >
> > @@ -505,8 +606,11 @@ static ssize_t send_buf(struct port *port, void
> *in_buf, size_t in_count,
> >
> >  	reclaim_consumed_buffers(port);
> >
> > -	sg_init_one(sg, in_buf, in_count);
> > -	ret = virtqueue_add_buf(out_vq, sg, 1, 0, in_buf, GFP_ATOMIC);
> > +	if (is_console_port(port))
> 
> I think you're misinterpreting what is_console_port() is.  It means if
> a port is associated with an hvc/tty device.

See below.

> 
> > +		sg_init_one(sg, in_buf, in_count);
> > +	else
> > +		sg_init_one(sg, buf->buf, in_count);
> > +	ret = virtqueue_add_buf(out_vq, sg, 1, 0, buf, GFP_ATOMIC);
> >
> >  	/* Tell Host to go! */
> >  	virtqueue_kick(out_vq);
> > @@ -669,7 +773,7 @@ static ssize_t port_fops_write(struct file *filp,
> const char __user *ubuf,
> >  			       size_t count, loff_t *offp)
> >  {
> >  	struct port *port;
> > -	char *buf;
> > +	struct port_buffer *buf;
> >  	ssize_t ret;
> >  	bool nonblock;
> >
> > @@ -696,11 +800,11 @@ static ssize_t port_fops_write(struct file
> *filp, const char __user *ubuf,
> >
> >  	count = min((size_t)(32 * 1024), count);
> >
> > -	buf = kmalloc(count, GFP_KERNEL);
> > +	buf = alloc_buf(port->out_vq, count);
> >  	if (!buf)
> >  		return -ENOMEM;
> >
> > -	ret = copy_from_user(buf, ubuf, count);
> > +	ret = copy_from_user(buf->buf, ubuf, count);
> >  	if (ret) {
> >  		ret = -EFAULT;
> >  		goto free_buf;
> > @@ -720,7 +824,7 @@ static ssize_t port_fops_write(struct file *filp,
> const char __user *ubuf,
> >  		goto out;
> >
> >  free_buf:
> > -	kfree(buf);
> > +	free_buf(buf);
> >  out:
> >  	return ret;
> >  }
> 
> OK, I now get what you did with send_buf() above.  However, send_buf()
> now should be completely broken for non-rproc devices: you're
> allocating a buf instead of a buf->buf and passing that on to
> send_buf() as a void*.  You should instead modify send_buf() to accept
> a struct port_buffer instead.
> 
> Second, send_buf() receives a struct port_buffer(), but in the
> 'is_console_port()' case, you ignore that fact, and just pass on the
> void* pointer to sg_init_one().  You should instead pass buf->buf.

OK, so the issue here it that currently put_chars() passes a
char-buffer to send_buf() instead of a port_buffer. The tests above
tries to handle this case, distingusing between a tty and char device.
I agree that this is not the best solution.

But if I change put_chars to create a port_buffer and copy
data into it I can avoid the crap you pointed at above.

...
> > -	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
> > +	if (!is_rproc_serial(vdev) &&
> > +	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
> >  		hvc_resize(port->cons.hvc, port->cons.ws);
> 
> Why do you want to ensure !is_rproc_serial() here?  As long as the
> device doesn't expose the VIRTIO_CONSOLE_F_SIZE feature, you should be
> fine, so this hunk can be dropped.

I need this test because virtio_check_driver_offered_feature() called
from virtio_has_feature will throw a BUG() if you test on a feature
not declared in the driver's feature-set.

> > @@ -1102,10 +1209,10 @@ static unsigned int fill_queue(struct
> virtqueue *vq, spinlock_t *lock)
> >
> >  	nr_added_bufs = 0;
> >  	do {
> > -		buf = alloc_buf(PAGE_SIZE);
> > +		buf = alloc_buf(vq, PAGE_SIZE);
> >  		if (!buf)
> >  			break;
> > -
> > +		memset(buf->buf, 0, PAGE_SIZE);
> 
> Why this memset here?
> 
> 1. alloc_buf() already does kzalloc()

It used to do that, but not anymore. This patch
changes kzalloc() to kmalloc() in alloc_buf()

> 2. Is there any specific reason you want the buffer to be zeroed?
> 
> I've recently realised zeroing out the buffer before giving it to the
> device serves no real purpose, and we're just slowing down the
> allocation here, so I'm tempted to convert the kzalloc() to
> kmalloc(), unless you have a specific need for zeroed pages.

Agree, the only reason is that I did memset was not to change legacy
behavior. I'd prefer to skip the memset too, so let's do that.

> 
> >  		spin_lock_irq(lock);
> >  		ret = add_inbuf(vq, buf);
> >  		if (ret < 0) {
> > @@ -1198,10 +1305,18 @@ static int add_port(struct ports_device
> *portdev, u32 id)
> >  		goto free_device;
> >  	}
> >
> > -	/*
> > -	 * If we're not using multiport support, this has to be a console
> port
> > -	 */
> > -	if (!use_multiport(port->portdev)) {
> > +	if (is_rproc_serial(port->portdev->vdev))
> > +		/*
> > +		 * For rproc_serial assume remote processor is connected.
> > +		 * rproc_serial does not want the console port, but
> > +		 * the generic port implementation.
> 
> s/but/only

OK, thanks.

> 
> > +		 */
> > +		port->host_connected = true;
> > +	else if (!use_multiport(port->portdev)) {
> > +		/*
> > +		 * If we're not using multiport support,
> > +		 * this has to be a console port.
> > +		 */
> >  		err = init_port_console(port);
> >  		if (err)
> >  			goto free_inbufs;
> > @@ -1277,6 +1392,16 @@ static void remove_port_data(struct port
> *port)
> >  	/* Remove buffers we queued up for the Host to send us data in.
> */
> >  	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> >  		free_buf(buf);
> > +
> > +	/*
> > +	 * Remove buffers from out queue for rproc-serial. We cannot
> afford
> > +	 * to leak any DMA mem, so reclaim this memory even if this might
> be
> > +	 * racy for the remote processor.
> > +	 */
> > +	if (is_rproc_serial(port->portdev->vdev)) {
> > +		while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
> > +			free_buf(buf);
> > +	}
> 
> braces around if can be dropped.

OK,

> > @@ -1722,13 +1847,17 @@ static int __devinit virtcons_probe(struct
> virtio_device *vdev)
> >  		goto free;
> >  	}
> >
> > -	multiport = false;
> > -	portdev->config.max_nr_ports = 1;
> > -	if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
> > -			      offsetof(struct virtio_console_config,
> > -				       max_nr_ports),
> > -			      &portdev->config.max_nr_ports) == 0)
> > +	/* Don't test MULTIPORT at all if we're rproc: not a valid
> feature! */
> > +	if (!is_rproc_serial(vdev) &&
> > +	    virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
> > +				  offsetof(struct virtio_console_config,
> > +					   max_nr_ports),
> > +				  &portdev->config.max_nr_ports) == 0) {
> >  		multiport = true;
> > +	} else {
> > +		multiport = false;
> > +		portdev->config.max_nr_ports = 1;
> > +	}
> 
> Why introduce the else part at all?  Let these two statements be as
> they are, and just add the !is_rproc_serial check to the if statement?

OK, I'll keep assignments before "if" and skip the else part.

...
> -	return register_virtio_driver(&virtio_console);
> > +	err = register_virtio_driver(&virtio_console);
> > +	if (err < 0) {
> > +		pr_err("Error %d registering virtio driver\n", err);
> > +		goto free;
> > +	}
> 
> This hunk is already present in linux-next; rebasing over that should
> get rid of it.

Sure, I'll rebase next patch to linux-next and send a new patch tomorrow.

Thanks,
Sjur
