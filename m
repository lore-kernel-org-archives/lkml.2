Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2ENI75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:59:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2ENI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:59:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
Date: Mon, 14 May 2012 08:59:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com> <CAMP44s1anUhxRqvdEVYdvu9+xedoQmRiEOHii3yaJQWfM2zauA@mail.gmail.com> <201205101049.58818.arnd@arndb.de>
In-Reply-To: <201205101049.58818.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205140859.52921.arnd@arndb.de>
X-Provags-ID: V02:K0:nCVHGGXnoz8UIBOnNBQ96YsoNRjDrPtNzYyvvcuscOX
 euRezi6Mu1E/vIJ1aAWyXQ5Ym/qV/TqhnRx0G6ay55E8z04XVe
 p+6aPvr4MErCPn1wcbdaNxuJu+Tv1JdTJzd0YtvUOpq8qSkhen
 Qg/ePlni2DDB+xN2Q853OED3Hh2Xv7Pk+nXjNgHhLCYS0QogH0
 TLfK8X2qMT19LcJ0bfbAwsNNsYzJXqTOuaGqxChkmc7ZThg9fo
 KTbrn1FtvgTpJvs3Xaqsnt+YOPlHvO8IcvUTsO0Ck2p79LOdFY
 5A0VApRU5jqKp8oMIPNIo/XMlReZGfEBsUOgvhAL77ECKaAz/u
 kZm+fcIVRbuE0m4JwCtY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012, Arnd Bergmann wrote:
> 176 is extremely bad, yes. A good value would be between 1 and 3.
> The algorithm is probably not 'la' but 'dl' and the page size (-b)
> could be smaller -- you have to test by passing '--blocksize=1024' to
> the --open-au test and see where it starts getting drastically
> smaller (if 4KB gives you about half the throughput of 8KB,
> 8KB is the page size). Those two can make the result better.
> 
> As I said, the erase block size is more likely to be 4MB, which
> will make the flashsim result worse.
> 
> Does flashsim give a better number for a trace taken with iotop
> running?
> 
> Can you send me or upload that iolog file?

Hi Felipe,

Any update? I'd really be interested in the trace file so that we
can look at data of a real-world case that hurts. I've discussed
your problem in the Linaro storage team meeting, and the question
came up whether this only happens with encryption enabled.

Which kind of encryption method do you actually use? Depending
on how the encryption is implemented, two things could possibly
go wrong that would not happen without it:

* A superblock is added to the partition that contains some metadata
relating to the encryption, so all data is offset by a few sectors,
turning a perfectly aligned partition into a misaligned one.

* All write accesses are sent as 4kb operations to the device rather
than getting at least flash-page-sized (e.g. 16kb) I/O most of the
time.

	Arnd
