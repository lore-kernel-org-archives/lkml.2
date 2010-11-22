Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0KVMIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:08:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:40447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0KVMIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:08:53 -0500
Message-ID: <4CEA5D4D.3050107@infradead.org>
Date: Mon, 22 Nov 2010 10:08:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Martin Wilks <m.wilks@technisat.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20101115102554.67514e8d.sfr@canb.auug.org.au> <20101122114315.687b4bd5.sfr@canb.auug.org.au>
In-Reply-To: <20101122114315.687b4bd5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 21-11-2010 22:43, Stephen Rothwell escreveu:
> Hi Mauro,
> 
> On Mon, 15 Nov 2010 10:25:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the v4l-dvb tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/media/dvb/dvb-usb/technisat-usb2.c: In function 'technisat_usb2_get_ir':
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:643: error: 'struct dvb_usb_device' has no member named 'rc_input_dev'
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:649: error: 'struct dvb_usb_device' has no member named 'rc_input_dev'
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:654: error: 'struct dvb_usb_device' has no member named 'rc_input_dev'
>> drivers/media/dvb/dvb-usb/technisat-usb2.c: At top level:
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:732: error: unknown field 'rc_props' specified in initializer
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:732: warning: braces around scalar initializer
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:732: warning: (near initialization for 'technisat_usb2_devices.rc.core.rc_interval')
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:733: error: field name not in record or union initializer
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:733: error: (near initialization for 'technisat_usb2_devices.rc.core.rc_interval')
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: error: field name not in record or union initializer
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: error: (near initialization for 'technisat_usb2_devices.rc.core.rc_interval')
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: warning: excess elements in scalar initializer
>> drivers/media/dvb/dvb-usb/technisat-usb2.c:734: warning: (near initialization for 'technisat_usb2_devices.rc.core.rc_interval')
>> make[5]: *** No rule to make target `drivers/media/rc/keymaps/rc-technisat-usb2.c', needed by `drivers/media/rc/keymaps/rc-technisat-usb2.o'.  Stop.
>>
>> Caused by commit f29235d71ad3995ef9f74ad2f5931eca4ecabdcd ("[media]
>> technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver")
>> interacting with commit 1639cc0c5348957c076c0304005632d4a1b63252
>> ("[media] ir-core: make struct rc_dev the primary interface").
>>
>> Please make sure your build tests build new/modified files.
>>
>> I have used the v4l-dvb tree from next-20101112 for today.
> 
> This is still failing ...


Hi Stephen,

It is a simple merge confict between two of my trees that got merged on my linux-next. 
The enclosed patch should fix it. I've already added it to my linux-next tree, so
the conflict should be fixed for tomorrow's build.

Mauro.

>From f80587fdbf8c949d2081aa0e4250d21c09058877 Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 22 Nov 2010 10:04:45 -0200
Subject: [PATCH] [media] linux-next: Fix technisat-usb2 compilation

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index bbba149..458fa27 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -246,7 +246,7 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->map_name = d->props.rc.core.rc_codes;
 	dev->change_protocol = d->props.rc.core.change_protocol;
 	dev->allowed_protos = d->props.rc.core.allowed_protos;
-	dev->driver_type = RC_DRIVER_SCANCODE;
+	dev->driver_type = d->props.rc.core.driver_type;
 	usb_to_input_id(d->udev, &dev->input_id);
 	dev->input_name = "IR-receiver inside an USB DVB receiver";
 	dev->input_phys = d->rc_phys;
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 83aa982..e818f0c 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -195,6 +195,7 @@ struct dvb_rc {
 	int (*rc_query) (struct dvb_usb_device *d);
 	int rc_interval;
 	bool bulk_mode;				/* uses bulk mode */
+	enum rc_driver_type driver_type;
 };
 
 /**
diff --git a/drivers/media/dvb/dvb-usb/technisat-usb2.c b/drivers/media/dvb/dvb-usb/technisat-usb2.c
index 97a6d45..b0e35e9 100644
--- a/drivers/media/dvb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/dvb/dvb-usb/technisat-usb2.c
@@ -640,18 +640,18 @@ unlock:
 	while (1) {
 		ev.pulse = !ev.pulse;
 		ev.duration = (*b * FIRMWARE_CLOCK_DIVISOR * FIRMWARE_CLOCK_TICK) / 1000;
-		ir_raw_event_store(d->rc_input_dev, &ev);
+		ir_raw_event_store(d->rc_dev, &ev);
 
 		b++;
 		if (*b == 0xff) {
 			ev.pulse = 0;
 			ev.duration = 888888*2;
-			ir_raw_event_store(d->rc_input_dev, &ev);
+			ir_raw_event_store(d->rc_dev, &ev);
 			break;
 		}
 	}
 
-	ir_raw_event_handle(d->rc_input_dev);
+	ir_raw_event_handle(d->rc_dev);
 
 	return 1;
 }
@@ -729,10 +729,8 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
 		.rc_codes    = RC_MAP_TECHNISAT_USB2,
 		.module_name = "technisat-usb2",
 		.rc_query    = technisat_usb2_rc_query,
-		.rc_props = {
-			.allowed_protos = IR_TYPE_ALL,
-			.driver_type    = RC_DRIVER_IR_RAW,
-		},
+		.allowed_protos = IR_TYPE_ALL,
+		.driver_type    = RC_DRIVER_IR_RAW,
 	}
 };
 
diff --git a/drivers/media/IR/keymaps/rc-technisat-usb2.c b/drivers/media/rc/keymaps/rc-technisat-usb2.c
similarity index 100%
rename from drivers/media/IR/keymaps/rc-technisat-usb2.c
rename to drivers/media/rc/keymaps/rc-technisat-usb2.c
