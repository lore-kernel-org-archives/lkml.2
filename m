Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0HaHNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:13:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62385 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab0HaHNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tMRRiIfCTLxduZFWespe2kIz7MiU4d2HTTKNN6BpZpvX7EJIz0k0v/RkdqMEVY+YjZ
         2csHyRodS/j8ZXXqGvICtuQYet248S9rqW9jldd+RlwAom/dLcQ94+s5wye4LXSO874b
         ptopBbjZB42EMo6y0QltMs0B9VNmjP6JncaLM=
MIME-Version: 1.0
In-Reply-To: <1283152361.16404.22.camel@4fid08082>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
	<1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
	<AANLkTim=Zq7Pxixdwe_H-659cLZ2yybediDURGwvoO3=@mail.gmail.com>
	<1283152361.16404.22.camel@4fid08082>
Date: Tue, 31 Aug 2010 12:43:16 +0530
Message-ID: <AANLkTikd8pCCn6aYL610qcUAHWsj5zoU8UBJ1pf4ffe1@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
From: Sundar <sunder.svit@gmail.com>
To: samu.p.onkalo@nokia.com
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Mon, Aug 30, 2010 at 12:42 PM, Onkalo Samu <samu.p.onkalo@nokia.com> wrote:
>
> It would require some more operations since the chip would loose its
> state totally. But yes, it could be done.
>
Yes. Something like re-programming the context. but it would make sure that
the module draws no power at all.

Also, would it not be correct to include a cancel_work_sync in case of
return here?

+fail4:
+       misc_deregister(&chip->miscdev);
+fail3:
+       ak8974_regulators_off(chip);
+fail2:
+       regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
+fail1:
+       kfree(chip);
+       return err;
+}

Cheers!
