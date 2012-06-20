Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2FTKWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:22:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57713 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2FTKWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120620105847.65cf37f2@endymion.delvare>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
 <1325847502-17841-3-git-send-email-djkurtz@chromium.org> <20120619204704.69454016@endymion.delvare>
 <20120620105847.65cf37f2@endymion.delvare>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 20 Jun 2012 18:21:47 +0800
X-Google-Sender-Auth: 9_dmayJtIeeFcmMnggMKjonT5E0
Message-ID: <CAGS+omDLYvqM69MFbU-pE6mAKT3tQnRw08aqbK73-hUBjOmZ0w@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] i2c: i801: enable irq for i801 smbus transactions
To: Jean Delvare <khali@linux-fr.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 4:58 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Tue, 19 Jun 2012 20:47:04 +0200, Jean Delvare wrote:
>> On Fri,  6 Jan 2012 18:58:21 +0800, Daniel Kurtz wrote:
>> > @@ -879,8 +953,24 @@ static int __devinit i801_probe(struct pci_dev *dev,
>> >     i801_probe_optional_slaves(priv);
>> >
>> >     pci_set_drvdata(dev, priv);
>> > +
>> > +   if (priv->features & FEATURE_IRQ) {
>> > +           init_waitqueue_head(&priv->waitq);
>> > +           spin_lock_init(&priv->lock);
>> > +
>> > +           err = request_irq(dev->irq, i801_isr, IRQF_SHARED,
>> > +                             i801_driver.name, priv);
>> > +           if (err) {
>> > +                   dev_err(&dev->dev, "Failed to allocate irq %d: %d",
>>
>> Missing "\n".
>>
>> > +                           dev->irq, err);
>> > +                   goto exit_del_adapter;
>> > +           }
>>
>> I believe order is wrong, and interrupt handler should be installed
>> _before_ registering the adapter. Otherwise you have a race condition
>> where the handler could be called before the waitqueue and spinlock are
>> initialized.
>
> Oh, and it's not a theoretical thing. I can reproducibly crash the
> kernel by removing and loading the i2c-i801 driver again. Swapping
> request_irq() and i2c_add_adapter() solves it.

Jean,

Thanks for taking a look at these patches... and for testing them!
They were from more than 7 months ago, so it will take me a little
time to context switch back to the point where I can really digest
your feedback and update and test them again myself.  But, I wanted to
just let you know that I am reading your review comments, and will get
to it as soon as I can.
Speaking of which, I have only seen comments on patches 1 & 2 so far.
Any comments on patch 3?

-Daniel

>
> --
> Jean Delvare
