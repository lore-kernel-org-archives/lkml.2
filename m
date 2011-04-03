Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1DCIwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 04:52:02 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53127 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1DCIwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 04:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jhVcDMW1WMBS0TFsFCtjfaDze0tbjfmRe45bIV0UTXi4pFQF3wo9PwosFLMMRg6vlP
         cJ9+a48dev1I0RcQx4tXDS5e80ywy1Yy2qOZHiq6FkF1s9zzuqKgAitNgEk7N+2jdhak
         LDg3ZqSkE4L4uFpfkFLUTINppyd5sfi/9XsIM=
MIME-Version: 1.0
In-Reply-To: <4D978930.1000909@codemonkey.ws>
References: <1301592656.586.15.camel@jaguar>
	<4D978930.1000909@codemonkey.ws>
Date: Sun, 3 Apr 2011 11:51:59 +0300
X-Google-Sender-Auth: reSA_20J62-er2LKtWvf2BTSGGo
Message-ID: <BANLkTinAHh9m8BYUJZ7sFeX58cZnNySGDg@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, avi@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org, joro@8bytes.org,
        penberg@cs.helsinki.fi, asias.hejun@gmail.com, gorcunov@gmail.com,
        mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Sat, Apr 2, 2011 at 11:38 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>> The goal of this tool is to provide a clean, from-scratch, lightweight
>> KVM host tool implementation that can boot Linux guest images (just a
>> hobby, won't be big and professional like QEMU) with no BIOS
>> dependencies and with only the minimal amount of legacy device
>> emulation.
>
> I see you do provide 16-bit entry points for Linux.  Are you planning on
> paravirtualizing this within Linux to truly eliminate the BIOS dependency?

No, we aren't planning that at the moment. We're trying to support
out-of-the-box distro kernels when possible which is why we went for
E820 emulation in the first place. The only hard requirement for
bootung userspace is CONFIG_VIRTIO_BLK but otherwise kernel binaries
should just work.

Furthermore, as the BIOS glue is really really small, I'm not sure if
we need to get rid of it completely. Do you have some scenario in mind
where paravirt solution would help?

                       Pekka
