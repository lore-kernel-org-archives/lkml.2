Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1FPFpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 01:45:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56937 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab1FPFpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 01:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Fpq1LlKBC3tcgqp9hT8R2nR4VW1Rek2k3j+exBsD/x0yDkkkPSejDOAKkZ1PYFzCxE
         VIbekG+b8IPXV9bHxWCaDtfjDxa1K0FfXFAB6K95XIsAtnP//R1IZa6nH9McwsDo2pEl
         E9rAFTjyjnzrpPYzoNn3A3w1n5HJA+qLXJKWY=
MIME-Version: 1.0
In-Reply-To: <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
References: <1308153214.7566.6.camel@jaguar>
	<4DF8DE26.1070301@redhat.com>
	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<4DF92C80.3030106@codemonkey.ws>
	<7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
Date: Thu, 16 Jun 2011 08:45:03 +0300
X-Google-Sender-Auth: YBgdP6MNa47lIztw4Jronqlz5_s
Message-ID: <BANLkTi=Jm_50m6qyfQPCF0PuwUfuDNwMtg@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: Alexander Graf <agraf@suse.de>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 1:07 AM, Alexander Graf <agraf@suse.de> wrote:
>> qemu-system-x86_64 -drive file=/dev/shm/test.qcow2,cache=writeback,if=virtio
>
> Wouldn't this still be using threaded AIO mode? I thought KVM tools used native AIO?

We don't use AIO at all. It's just normal read()/write() with a thread
pool. I actually looked at AIO but didn't really see why we'd want to
use it.
