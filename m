Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0FYAYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 20:24:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42863 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0FYAYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 20:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Y/rarN4lTZV8vf/DTpZgEPdRAGuSPFriHFLV1v+TgLXS5ASPMJIxtedeCmd8+vLwko
         jz/FkSLuHUuQoQKyEq0nyIfw+kCAcQJf3MSVR1O6H8nuXNKm9KGRWBE1/kWe9G0oH0Rd
         Q11WMecVPhK3l0/JXUH4wm8+iSpo4la0wXv04=
Message-ID: <4C23F71F.7000806@gmail.com>
Date: Thu, 24 Jun 2010 18:23:59 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Kurt Newman <knewman@globaldataguard.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32.1 kernel unable to use more than 2 of 16 CPUs on Intel
 E5540 (i7)
References: <4C23D1E9.9050007@globaldataguard.com> <adahbksqe71.fsf@roland-alpha.cisco.com>
In-Reply-To: <adahbksqe71.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 04:05 PM, Roland Dreier wrote:
> Your config seems to have CONFIG_PM and therefore CONFIG_ACPI disabled.
> So the kernel is relying on mptable information.  Unsurprisingly on a
> modern system, that info is probably broken -- since everything would
> have been tested with ACPI.
>
> Try turning on CONFIG_ACPI and see if that helps at all.

Indeed, not having ACPI enabled will prevent any multi-core CPU 
detection. ACPI really has to be enabled for any modern x86 system to 
work properly.

I'd think that the CONFIG_ACPI really should be defaulted on more 
strongly - maybe force it on if CONFIG_EMBEDDED isn't set or something..
