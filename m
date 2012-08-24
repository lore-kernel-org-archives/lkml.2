Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2HXJgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:36:13 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:50139 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2HXJgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:36:09 -0400
Message-ID: <50374B69.3040002@laposte.net>
Date: Fri, 24 Aug 2012 11:37:45 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v4 2/2] input: misc: New USB eBeam input driver.
References: <1345673514-11575-1-git-send-email-yann.cantin@laposte.net> <1345673514-11575-3-git-send-email-yann.cantin@laposte.net> <1368810.q4rGz16CTW@linux-lqwf.site>
In-Reply-To: <1368810.q4rGz16CTW@linux-lqwf.site>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 23/08/2012 09:23, Oliver Neukum a écrit :
> On Thursday 23 August 2012 00:11:54 Yann Cantin wrote:
>> +static int ebeam_resume(struct usb_interface *intf)
>> +{
>> +       struct ebeam_device *ebeam = usb_get_intfdata(intf);
>> +       struct input_dev *input = ebeam->input;
>> +       int result = 0;
>> +
>> +       mutex_lock(&input->mutex);
>> +       if (input->users)
>> +               result = usb_submit_urb(ebeam->irq, GFP_NOIO);
>> +       mutex_unlock(&input->mutex);
>> +
>> +       return result;
>> +}
>> +
>> +static int ebeam_reset_resume(struct usb_interface *intf)
>> +{
>> +       struct ebeam_device *ebeam = usb_get_intfdata(intf);
>> +       struct input_dev *input = ebeam->input;
>> +       int err = 0;
>> +
>> +       /* restart IO if needed */
>> +       mutex_lock(&input->mutex);
>> +       if (input->users)
>> +               err = usb_submit_urb(ebeam->irq, GFP_NOIO);
>> +       mutex_unlock(&input->mutex);
>> +
>> +       return err;
>> +}
> 
> These functions are identical. You should unify them.

Removed reset_resume from the driver (optional, and not needed
for this hardware).

Thanks.

-- 
Yann Cantin
A4FEB47F
--
