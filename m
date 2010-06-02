Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab0FBS5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:57:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:56478 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab0FBS5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=K2gjrn3VD1H+dsdz7uY3iU9dFXy4/rcpZ4VtVay4H8/pUsiR79310cjueErkOwA7Ei
         zWbOIXmPZdZIrS208W71LDzDbGKg4FeRfkp/JGRPHM1y8zfdeKujBoG7mY25gQUVApwr
         /cu0GEnDLjUACZnhn8d8Bk+n32EuaAbv6MT9s=
Subject: strange problem with ricoh-mmc
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 21:56:58 +0300
Message-ID: <1275505018.4215.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maybe this is my fault, don't know, but I found and now confident that
new and possible old version of ricoh-mmc causes troubles after
suspend/resume.

Namely there are two problems.
One is that sometimes card detection on xD controller stops working.
That is it doesn't respond to insert/remove events, and suspend to ram
just updates that once. Granted I wrote this driver, but it appears to
work without richoh-mmc.

Another problem that is unrelated to xD is that sometimes sdhci
conroller issues an interrupt storm, and does so until its driver is
reloaded. At that point it refuses to load with missing voltage levels.

I never seen these without ricoh-mmc pci quirk.

Both problems are semi-rare.

So just one question, did you see these problems?
Do you have a clue on how to proceed?


Best regards,
Maxim Levitsky

