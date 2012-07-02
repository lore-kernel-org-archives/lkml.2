Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2GBIno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:43:44 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35587 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2GBInn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <4FF15E92.3040503@mev.co.uk>
References: <1341149798-12695-1-git-send-email-devendra.aaru@gmail.com>
	<4FF15E92.3040503@mev.co.uk>
Date: Mon, 2 Jul 2012 14:13:42 +0530
Message-ID: <CAHdPZaM_u4-Nry3s98yTcOnEje+Je6iu5LLe6frpc3+MWVb_QQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging/comedi/drivers: release allocated I/O region
 if alloc_private fails
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 2:10 PM, Ian Abbott <abbotti@mev.co.uk> wrote:
> On 2012-07-01 14:36, Devendra Naga wrote:
>>
>> if alloc_private fail, we wont' release the I/O region,
>> which was request_region 'ed.
>>
>> release the allocated I/O region if alloc_private fails.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> ---
>
>
> No.  The I/O region will be deallocated in fl512_detach() because
> dev->iobase has been set non-zero.  fl512_detach() will be called by the
> comedi core if fl512_attach() returns an error.  This is an unusual aspect
> of the comedi drivers.
>
Oh, i didn't see the comedi core, i went and saw that its not freed
up, so actaully driver unload wont' be called if driver attach , probe
fail. so i started sending this patch.

Sorry.
> --
> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
> -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

Devendra.
