Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1BHNQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:16:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65092 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1BHNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:16:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Xwr/cuaUzgA8IlWE8celbErDP4pFpgpOTjhyABwBQ3aJ/SvYyb4qczOCQtDVhHHlUw
         2EWRGsNKOTAQjvfUP2tdB59YBmtWgv9RRw7tFby2iwv74X1QvryY7dBJKqq2ev9WAtFL
         ltckpM2ZN9R26q5cgx4w+MqfArD4o4+dw4twA=
MIME-Version: 1.0
In-Reply-To: <20110208130701.19709cc6@lxorguk.ukuu.org.uk>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
Date: Tue, 8 Feb 2011 14:16:09 +0100
Message-ID: <AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 2:07 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 08 Feb 2011 13:24:09 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
>> >From 8acc9371550ce5f98da56f6888ae4b898096ed2c Mon Sep 17 00:00:00 2001
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Tue, 8 Feb 2011 12:39:25 +0100
>> Subject: [PATCH 05/20] pata_efar: always program master_data before slave_data
>>
>> We may need to set SITRE before programming slave_data.
>
> Do you have a documentation cite for this or is it random fiddling with a
> driver you can't test ?

It is good to enable SITRE register before programming it and all
Intel controllers
(from which EFAR chipset is derived) are programmed this way (per ata_piix.c).
