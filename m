Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966381Ab0GSTWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:22:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56136 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965308Ab0GSTWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ANCLM7vDhOZyxLMkMvQKAoLnILZkjpzPjV06cih38UpfXT+ARb3Yz05xi3ivEFFnRw
         bfod4+ogSdOLTa0OrOur5nPA6NiKMaZMBQtZ2kFzxcUVCHdvVgHXpaluAixFg2LOfKxz
         CG7baAqfW7WqEO0T493ZjRU/d2dK/fLQpGM9w=
MIME-Version: 1.0
In-Reply-To: <AANLkTinSjNHPyariuoUuYZCRcbTf8nQALma81I4CPdsv@mail.gmail.com>
References: <AANLkTimhqRAMjaVNwo50GJO9B6kTzySWVtK04gEdu0rg@mail.gmail.com>
	<4C37C365.6090508@gmail.com>
	<AANLkTilH9Hn0MHvfOEOyEeRmDcPTrRXIFB3K8pq31yIH@mail.gmail.com>
	<AANLkTikZCBrZwROGgGTj-JREywN3fUnvaANtTGgkok--@mail.gmail.com>
	<AANLkTinbj4ScYca7WlnUiIKgsVkVbQwEO4ypgxFe5Zbo@mail.gmail.com>
	<AANLkTinSjNHPyariuoUuYZCRcbTf8nQALma81I4CPdsv@mail.gmail.com>
Date: Mon, 19 Jul 2010 13:22:15 -0600
Message-ID: <AANLkTik9OzNu-jaE6qiJJznb0riOn5CsgPO6aBoDaYHJ@mail.gmail.com>
Subject: Re: Interrupt Affinity in SMP
From: Robert Hancock <hancockrwd@gmail.com>
To: Bryan Hundven <bryanhundven@gmail.com>
Cc: linux-kernel@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 2:02 PM, Bryan Hundven <bryanhundven@gmail.com> wrote:
> Please see the two attached examples.
>
> Notice on the 5410 example how we start with the affinity set to 0xff,
> and change it to 0xf0.
> This should spread the interrupts over the last 4 cores of this quad
> core - dual processor system.
>
> Also notice on the 5645 example, with the same commands we start with
> 0xffffff and change to 0xfff000 to spread the interrupts over the last
> 12 cores, but only the first of the last twelve cores receive
> interrupts.
>
> This is the inconsistency I was trying to explain before.

As I mentioned before, I believe the behavior in this case is chipset
dependent, and potentially not something the kernel has control over.
In most cases distributing the same interrupt across multiple cores is
likely a bad idea in any case, unless the interrupt load is actually
so high that a single CPU can't handle it.
