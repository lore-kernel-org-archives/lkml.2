Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0KAJyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:54:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40221 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0KAJyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CSxGSBiqwhcZJCLDByKNE7Uw21HUaPboeGbLGTXYbJcXSxNHbzxY7lHcUYV2QtJZ6p
         2G9LCVKjuIrrvX7dtg7Fmye2/M+iPgn+fHoibTwoQk7puYB/Ai6t253AVXb/UKi1H2Tr
         BaVSOD1HRjZ+sZYa9XSXchWPVbJjVNumMxnW8=
Date: Mon, 1 Nov 2010 17:59:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: tingwei liu <tingw.liu@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: How many params can be accept by kernel module at most?
Message-ID: <20101101095922.GE6023@cr0.nay.redhat.com>
References: <AANLkTikfW7QfXX76JM=pDYuQYexPvQz3hrAE=B3YMD5x@mail.gmail.com>
 <20101101092947.GB6023@cr0.nay.redhat.com>
 <AANLkTi=vF50JAFQRMWRDKpbk157amaXpDetna=8==pHn@mail.gmail.com>
 <AANLkTikkh+Pif7DuP3p-fH2=5_otX7N0NSjSB2h13yFC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikkh+Pif7DuP3p-fH2=5_otX7N0NSjSB2h13yFC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 05:49:53PM +0800, tingwei liu wrote:
>The params are transferred by command line. And the params are all in
>program statically. So the stack size determine the params number. For
>example: stack size is 4K,and params are unsigned int type with 4
>bytes,so the max number of params is 1 thousand。
>

Please don't top-reply.

That is not true, the parameters are passed via 'uargs' of init_module()
dynamically, this is when you invoke modprobe/insmod.

For your own kernel module, you may use module_param() to provide
parameters, the max of this is limited to the size of ELF section size,
since they are stored in "__param" section.
