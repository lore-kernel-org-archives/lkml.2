Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0DOTQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:16:18 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:49679 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0DOTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=m+ULeAVeNc0SPW1Zt1FAGQl5NPXWvflQ/1LALaUD9HWQQCddkRZuusRWB+/snMTkrA
         jU7CUAH3koB0zsQ0rYwsoKqWO2aBYm9DK9MDd067UyB4AQltUmiC6ml0fCwkrpHpQRgL
         N9pLJf0jICx3rzOABOnJrfibrWnlJEFHwwZ+M=
Message-ID: <4BC76645.50401@gmail.com>
Date: Thu, 15 Apr 2010 12:17:25 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.34-rc4: acpi boot-time oops on FSC Amilo Pa 3553
References: <19399.23074.26023.534765@pilspetsen.it.uu.se>
In-Reply-To: <19399.23074.26023.534765@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 11:25 AM, Mikael Pettersson wrote:
> Kernels up to and including 2.6.34-rc3 boot fine on my Amilo Pa 3553,
> but 2.6.34-rc4 always oopses during boot in acpi.  Without a serial port
> I cannot capture the entire oops, but it goes something like this:
>
> __driver_attach
> bus_for_each_dev
> driver_attach
> __driver_attach
> bus_add_driver
> acpi_device_remove
> driver_register
> async_thread
> proc_mkdir_mode
> async_thread
> acpi_battery_init_async
> async_thread
> schedule
> default_wake_function
> async_thread
> kthread
> kthread
> kernel_thread_helper
> EIP: acpi_ex_read_data_from_field+0x16e
>
> Any suggestions for revisions to try to revert?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


sounds similar to this:
https://bugzilla.kernel.org/show_bug.cgi?id=%2015749
if so try the patch there and see if
you can boot.

Justin P. Mattock
