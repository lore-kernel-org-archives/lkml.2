Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab2HXJ3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:29:41 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:39321 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab2HXJ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:29:35 -0400
Message-ID: <503749DC.2080808@laposte.net>
Date: Fri, 24 Aug 2012 11:31:08 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120717 Thunderbird/10.0.6
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v4 2/2] input: misc: New USB eBeam input driver.
References: <1345673514-11575-1-git-send-email-yann.cantin@laposte.net> <1345673514-11575-3-git-send-email-yann.cantin@laposte.net> <5832321.EK5PCgIIzt@linux-lqwf.site>
In-Reply-To: <5832321.EK5PCgIIzt@linux-lqwf.site>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 23/08/2012 08:54, Oliver Neukum a écrit :
> On Thursday 23 August 2012 00:11:54 Yann Cantin wrote:
>> +       /* input final setup */
>> +       err = input_register_device(ebeam->input);
>> +       if (err) {
>> +               dev_dbg(&intf->dev,
>> +                       "%s - input_register_device failed, err: %d\n",
>> +                       __func__, err);
>> +               goto out_free_urb;
>> +       }
>> +
>> +       ebeam_setup_input(ebeam, input_dev);
>> +
>> +       /* usb final setup */
>> +       usb_set_intfdata(intf, ebeam);
> 
> Hi,
> 
> this looks like a classic race. You initialize the device after you
> register it. However, it may be used at that time.

Ok, moved ebeam_setup_input before input_register_device.

Thanks.

-- 
Yann Cantin
A4FEB47F
--
