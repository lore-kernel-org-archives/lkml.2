Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0JBK2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 06:28:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39965 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab0JBK2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 06:28:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w/pwaAJwTxTk9bBbY4lmoSGiaXkfXuOfSDJ8HoyCdGPlAIlHN/oxoBSqU/l+2OKvGM
         CRLHT5PFIchWLZwiisuEJhVjxcUnxECNxG026YAi0F5svLGuAR5E2YGM5pI6EEUz5U5k
         OyFEqUP6967+YSRttwsMXr+X6CoqyTXBEbVy0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=cfyBTUHfxXBDf_mAdsfz=Fw01rxxFeeR7WANn@mail.gmail.com>
References: <1286002121-3694-1-git-send-email-rahul.ruikar@gmail.com>
	<AANLkTi=8LGCVqchpQrB+31FRqK04+3xLFCuak0S1FHpK@mail.gmail.com>
	<AANLkTimnSzAWJW417_XR60umT_k47AFWDdDPPD3yhbLG@mail.gmail.com>
	<AANLkTinq16F1oh=gj_hs=w8fMWo7VuArC3m4-SUWp+Nr@mail.gmail.com>
	<AANLkTi=cfyBTUHfxXBDf_mAdsfz=Fw01rxxFeeR7WANn@mail.gmail.com>
Date: Sat, 2 Oct 2010 18:28:39 +0800
Message-ID: <AANLkTim1SDjhautuTiSO5hStD3qAKa5GUanF3aP51UYT@mail.gmail.com>
Subject: Re: [PATCH] usb: core: endpoint: Fix error path
From: Ming Lei <tom.leiming@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        asanchez@neurowork.net, rjw@sisk.pl, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/2 Rahul Ruikar <rahul.ruikar@gmail.com>:
> Thanks Ming.
> I have certain doubts related to device_unregister()
>
> In some of USB related code..
> kfree() is called after device_unregister() ...  device_unregister()
> also internally calls put_device()... is that correct behavior or I'm
> missing something here..

If no other external reference to device before put_device in device_unregister,
dev.release will be called from put_device to free something, which depends
on your implement for dev.release.

> ex.
> file : drivers/usb/gadget/fsl_udc_core.c
> function : static int __init fsl_udc_probe(struct platform_device *pdev)

Once reaches err_unregister, double free of udc_controller may be
triggered, so fix should be needed.

-- 
Lei Ming
