Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0GKBVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 21:21:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35273 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0GKBVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 21:21:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J/5I94W2IIlf7QEzXtjrm2GelUa3M1Xz+CYo7q0U06+ogbKy5zq0US8Knkj6T6P6x4
         CvSFNP0z5TQlo5ev8JSo9V1UmZAlO4vxXPA2vsN9yA9+xt301hwBLVNwDBxSF9C19Hl3
         Qg7pSpTIIHWqVPQnNxo/p97iTh8rvQrV+rNGo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikZCBrZwROGgGTj-JREywN3fUnvaANtTGgkok--@mail.gmail.com>
References: <AANLkTimhqRAMjaVNwo50GJO9B6kTzySWVtK04gEdu0rg@mail.gmail.com>
	<4C37C365.6090508@gmail.com>
	<AANLkTilH9Hn0MHvfOEOyEeRmDcPTrRXIFB3K8pq31yIH@mail.gmail.com>
	<AANLkTikZCBrZwROGgGTj-JREywN3fUnvaANtTGgkok--@mail.gmail.com>
Date: Sat, 10 Jul 2010 19:20:57 -0600
Message-ID: <AANLkTinbj4ScYca7WlnUiIKgsVkVbQwEO4ypgxFe5Zbo@mail.gmail.com>
Subject: Re: Interrupt Affinity in SMP
From: Robert Hancock <hancockrwd@gmail.com>
To: Bryan Hundven <bryanhundven@gmail.com>
Cc: linux-kernel@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 1:46 PM, Bryan Hundven <bryanhundven@gmail.com> wrote:
> I was able to set eth0 and it's TxRx queues to cpu1, but it is my
> understanding that 0xFFFFFFFF should distribute the interrupts across all
> cpus, much like LOC in my output of /proc/interrupts.
>
> I don't have access to the computer this weekend, but I will provide more
> info on Monday.

That may be chipset dependent, I don't think all chipsets have the
ability to distribute the interrupts like that. Round-robin interrupt
distribution for a given handler isn't optimal for performance anyway
since it causes the relevant cache lines for the interrupt handler to
be ping-ponged between the different CPUs.

>
> -bryan
>
> On Jul 9, 2010 5:48 PM, "Robert Hancock" <hancockrwd@gmail.com> wrote:
>
> On 07/09/2010 04:59 PM, Bryan Hundven wrote:
>>
>> Mauro, list,
>>
>> (please CC me in replies, I am not...
>
> Tried changing these files to exclude CPU0?
>
> Have you tried running the irqbalance daemon? That's what you likely want to
> be doing anyway..
>
>> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
>>
>> =====8<=====8<=====8<==...
