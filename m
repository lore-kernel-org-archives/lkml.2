Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1AZUeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:34:11 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39754 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1AZUeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S2sqztxQAYSFg5XjZ18y5fS+t8xI1A8tQ3oTT6pjj28vP2U0hnflhyIUHOUE92mNrV
         NKaxDCfUxiPJfhU5/EAKMq8rQwaSWohFC1zUnuLwvD7HtCAtYbRSbg0el0+2YkNbm10m
         EcFtzV7ocLzunQkNQBqVFdsE8B8tcrExxoYUk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
References: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
Date: Wed, 26 Jan 2011 12:34:06 -0800
Message-ID: <AANLkTikECrLeVGQt6ui0eHVdohgtW7-ksetrsKp4sRNw@mail.gmail.com>
Subject: Re: 3w-sas 0000:02:00.0: vpd r/w failed.
From: adam radford <aradford@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 11:45 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
> [475380.769837] 3w-sas 0000:02:00.0: vpd r/w failed.  This is likely a
> firmware bug on this device.  Contact the card vendor for a firmware update.
>

Justin,

pci_vpd_pci22_wait() uses 'HZ' and time_after() to detect a timeout of
reading the vpd.

Do you have your kernel compiled with the following?

-# CONFIG_NO_HZ is not set
-# CONFIG_ACPI_PROCESSOR is not set
-# CONFIG_CPU_FREQ is not set

-Adam
