Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab1EXO2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:28:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47689 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab1EXO2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=mbLKHILyVD4u5b/WfMJQvBs3kOA/NodEPBma74WprpxScxKAuHpLngZgJp+059EKXb
         sDLeq7Z8MVHYtqNlavQGPN5/D/KQw+zDrxS31ZP46InofWtWufoawJRPOA7wRYHADvs4
         9tXJlZkjqU6UyDH7eQP8asL/YjAbqRY8IsUok=
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: ramoops: is using platform_drivers correct?
Date: Tue, 24 May 2011 16:28:08 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-ck3; KDE/4.6.3; x86_64; ; )
Cc: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        marco.stornelli@gmail.com, linux-kernel@vger.kernel.org
References: <201105231527.53805.stevie.trujillo@gmail.com> <BANLkTimCaEPVeBj_00HvqGp7j+_PUvs2Fg@mail.gmail.com> <BANLkTikeUMFyLuWcHbW4TrF1wqM8_F_Vnw@mail.gmail.com>
In-Reply-To: <BANLkTikeUMFyLuWcHbW4TrF1wqM8_F_Vnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105241628.08819.stevie.trujillo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 May 2011 16:16:13 Kyungmin Park wrote:
> On Tue, May 24, 2011 at 11:12 PM, Américo Wang <xiyou.wangcong@gmail.com> 
wrote:
> > On Tue, May 24, 2011 at 2:14 PM, Kyungmin Park <kmpark@infradead.org> 
wrote:
> >> On Tue, May 24, 2011 at 2:49 PM, Américo Wang <xiyou.wangcong@gmail.com> 
wrote:
> >>> Huh? Is this for x86 too? Why so unfriendly for end-users?
> >> 
> >> I don't know which address is acceptable for x86, in case of ARM, each
> >> SoCs has different SRAM address. so it's not good to define for all
> >> SoCs and ARM.
> >> 
> >>> I think we need some kernel parameter like 'crashkernel=' (or memmap=)
> >>> to reserve memory for ramoops, right?
> >> 
> >> The first implementation is just module parameters.
> >> ramoops.address=0x??????? ramoops.size=0x????. So I patched it as
> >> using platform devices.
> >> and the reason use the platform is it's dependent on each SoCs and board
> >> usage.
> > 
> > But the result is that this makes end-users harder to use it.
> > 
> > Using platform API still relies on a hard-code address, at least in
> > your example,
> > so, why not leave it as a module parameter to let user to find the
> > correct address?
> 
> It's possible. I just make it possible to use the platform driver. you
> can specify the original method.

I don't think it's possible without also having a platform_device. 
ramoops_probe is never called here, I think platform_driver_probe returns -
ENODEV.

static int __init ramoops_init(void)
{
    return platform_driver_probe(&ramoops_driver, ramoops_probe);
}

Maybe one could run platform_driver_probe() only if (!mem_address && 
!mem_size)?

Unrelated question: should the printk()s end with "\n"? I see they do that 
other places in the kernel.
