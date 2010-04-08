Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab0DHQYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:24:34 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:51247 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab0DHQYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RMOq+6lLEssz3haSRfMBQVsS+eN/EwHtH/HF5VJT3qnr2YYnewEcZ+vpaW+SV4kjsf
         UnmSfVFWv6whJlYqLZu0a2tQVi3HEmwiLHmPqXyUnXDKxFZrVUEKrUpNJufGjT+vcEC5
         Qc8kaQ2qF3rrJVxywlndNtmoBsZtrDpUAFzU0=
MIME-Version: 1.0
In-Reply-To: <4BBDEF93.6070306@ladisch.de>
References: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>
	 <4BBC9CA1.5080102@ladisch.de>
	 <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>
	 <4BBD1957.90502@gmail.com>
	 <k2l5bdc1c8b1004072051h957c3f1crf0a139bd96a093a4@mail.gmail.com>
	 <v2h51f3faa71004072054y4733bf9bq80a04574bebbadba@mail.gmail.com>
	 <4BBD7997.1020803@ladisch.de>
	 <l2v5bdc1c8b1004080753k7787e635p4a70d4a1a777984d@mail.gmail.com>
	 <4BBDEF93.6070306@ladisch.de>
Date: Thu, 8 Apr 2010 09:24:31 -0700
Message-ID: <z2i5bdc1c8b1004080924q1b8d3994vd69c9c9dd0bb2f78@mail.gmail.com>
Subject: Re: Failed to initialize MSI interrupts && ioremap reserve_memtype 
	failed -22
From: Mark Knecht <markknecht@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 8:00 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Mark Knecht wrote:
>> ioremap reserve_memtype failed -22
>> phys_addr: 0xcf7fe000, size: 0x2000
>
> What is at this address in /proc/iomem?
>
>> Call Trace:
>>  [<ffffffff8101b7ee>] ? __ioremap_caller+0x1e2/0x30e
>>  [<ffffffffa052345b>] ? _nv006553rm+0x3a/0x40 [nvidia]
>
> I didn't find this function name in the kernel source ...
>
>
> Regards,
> Clemens
>

Is there a serious chance this is somehow related to the closed source
nvidia driver? I could investigate switching to the in kernel driver
although that might take me a little time to get to.

Being that I'm not 100% sure which address you meant here's everything:

k2 ~ # cat /proc/iomem
00000000-0008efff : System RAM
0008f000-0008ffff : reserved
00090000-0009cfff : System RAM
0009d000-0009ffff : reserved
000e0000-000fffff : reserved
00100000-cf4bcfff : System RAM
  01000000-013466b6 : Kernel code
  013466b7-0166ab1f : Kernel data
  016e3000-01737eb3 : Kernel bss
cf4bd000-cf4befff : reserved
cf4bf000-cf4c3fff : System RAM
cf4c4000-cf7befff : ACPI Non-volatile Storage
cf7bf000-cf7defff : System RAM
cf7df000-cf7fefff : ACPI Tables
cf7ff000-cf7fffff : System RAM
cf800000-cfffffff : reserved
d0000000-d2ffffff : PCI Bus 0000:02
  d0000000-d1ffffff : 0000:02:00.0
  d2000000-d2ffffff : 0000:02:00.0
    d2000000-d2ffffff : nvidia
d3000000-d30fffff : PCI Bus 0000:07
  d3000000-d3003fff : 0000:07:03.0
  d3004000-d30047ff : 0000:07:03.0
    d3004000-d30047ff : firewire_ohci
d3100000-d31fffff : PCI Bus 0000:06
  d3100000-d31003ff : 0000:06:00.0
    d3100000-d31003ff : ahci
d3200000-d321ffff : 0000:00:19.0
  d3200000-d321ffff : e1000e
d3220000-d32207ff : 0000:00:1f.2
  d3220000-d32207ff : ahci
d3221000-d32213ff : 0000:00:1d.7
  d3221000-d32213ff : ehci_hcd
d3222000-d32223ff : 0000:00:1a.7
  d3222000-d32223ff : ehci_hcd
d3223000-d3223fff : 0000:00:19.0
  d3223000-d3223fff : e1000e
e0000000-efffffff : PCI Bus 0000:02
  e0000000-efffffff : 0000:02:00.0
f0000000-f0003fff : 0000:00:1b.0
  f0000000-f0003fff : ICH HD audio
f0004000-f00040ff : 0000:00:1f.3
f8000000-fcffffff : reserved
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fee00000-fee00fff : Local APIC
ffe00000-ffffffff : reserved
100000000-1afffffff : System RAM
k2 ~ #

Cheers,
Mark
