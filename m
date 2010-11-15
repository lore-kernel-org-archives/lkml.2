Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0KOQOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:14:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62144 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab0KOQOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:14:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=e26ihB6ygM6TmQ7eTZARvH+50EXKdtGBqVlefJHwDolUnZ+Zs0AUDcAcl5rDlnk0OW
         tCpNI0ayYj/52/kcGtYInHgRAYL3bWO6BCAKyFqKpt7Bl1cFVVa9gOnEv1vx57lxhKdX
         MeuG4wu3p9kvvqNaD5nTW3uzVHhx/h6OGpReo=
MIME-Version: 1.0
In-Reply-To: <3B38AD35-39A2-4A54-8109-65D6DE436227@kernel.crashing.org>
References: <1289477789-10651-1-git-send-email-leoli@freescale.com>
 <54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org>
 <AANLkTi=1nutREorMFY2VJyUYQD0SHfiSeskw-u22P+R-@mail.gmail.com> <3B38AD35-39A2-4A54-8109-65D6DE436227@kernel.crashing.org>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Mon, 15 Nov 2010 10:13:58 -0600
Message-ID: <AANLkTin8+13mr-tV-2iCG+zGRfF6xZ23cN+=44dsaQor@mail.gmail.com>
Subject: Re: [PATCH v2] fsldma: add support to 36-bit physical address
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>, dan.j.williams@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 9:16 AM, Kumar Gala <galak@kernel.crashing.org> wrote:

> The programming model (if you look at the free-space in the registers and data structures) supports a 64-bit address.  I'm trying to avoid changing the driver in the future if we have >36-bit.  However this is such a minor worry that I'll stop and just ack the patch as is.

I must still be missing something.  I'm looking at the description of
the SATR register in the MPC8572 RM, and it shows this:

0 - 3 |   4 - 5   |     6     |   7  |   8 - 11  |   12 - 15  | 16-21 | 22-31
 ---  | STFLOWLVL | SPCIORDER | SSME | STRANSINT | SREADTTYPE |  ---  |  ESAD

The most that we can extend ESAD to is 16 bits, for a total of a
48-bit physical address.  Where are the other 16 bits supposed to go?

-- 
Timur Tabi
Linux kernel developer at Freescale
