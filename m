Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1BREVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:21:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41260 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1BREVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:21:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EuqFif99Xn6hkNV3HcfuZmXj5uor0W2rMZXZmC+x3lhwaBStXiR5ry5ieR7NAT9wHT
         BOOcHsbHsjyumzfhCZ4w5wL67WW2kuQ13v/yuSus010Qw/b5HnJbMH3l2jrb3BmPV5K+
         lxQ1G4A9soLqh+xVoKQ1tmitpAbU+eeozwqXU=
MIME-Version: 1.0
Date: Fri, 18 Feb 2011 13:21:28 +0900
Message-ID: <AANLkTikcC1o0zM5ChPhhvhbLPtCNzrtUJ7HCNHHGTcaU@mail.gmail.com>
Subject: problems with GPIO
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi There,

I am rather a novice with linux kernel and I have this problem.
My board is  OMAP 3530 based and I use GPIO 21 to detect an external
device plug-in.
Now, when the board is just booted (after a complete power disconnect
), the GPIO is high, and when I plug in my external device, the GPIO
goes low, and I am able to detect it.
However, I see the voltage level still low after I remove the external
plug-in, and any further plug-ins, remain un-detected.
My H/W engineers say it is some config I am missing in Kernel.
can someone point me?

my code snippet is like:

    omap_mux_init_gpio(MY_GPIO,  OMAP_PIN_INPUT_PULLDOWN  );
    gpio_request(MY_GPIO,"CABLE IN");
    gpio_direction_input(MY_GPIO);
    gpio_set_value(MY_GPIO,1);

    set_irq_type(MY_IRQ,
            IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING
            );

    err = request_threaded_irq (MY_IRQ, NULL, my_dev_irq_thread,
           IRQF_TRIGGER_FALLING,
           "MY_DEV", NULL);

As I mentioned "my_dev_irq_thread" gets called when the actual GPIO is
detected to be going low.

Any pointers?
Thanks & regards
Murali
