Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1FPGVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:21:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36784 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1FPGVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SM0eyhq9ogu09KKoyQFFWf+Sjw0X1XTxhPbJqklA4mHbecR9c5zppw1U0OgHFbVnMm
         YSPIMtckVCBTFPs8S0L6wyRnuVbCB/T/AMZ5EOf8/jRWpFdvIy3qO20w2WTi7IWrcvQf
         B9ilcv7Gm5N8++2t6VYvmUNRQGUGmpDf4NQ7Y=
MIME-Version: 1.0
In-Reply-To: <BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
References: <1308153214.7566.6.camel@jaguar>
	<4DF8DE26.1070301@redhat.com>
	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<4DF92C80.3030106@codemonkey.ws>
	<7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
	<4DF93010.1040006@codemonkey.ws>
	<4DF935C1.4020000@codemonkey.ws>
	<BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
Date: Thu, 16 Jun 2011 09:21:03 +0300
X-Google-Sender-Auth: 1hmLkGjLYzp3TDE_FhoEtJDegvQ
Message-ID: <BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Alexander Graf <agraf@suse.de>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 1:44 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>>> That's probably why it's fast, it doesn't preserve data integrity :(
>>
>> Actually, I misread the code.  It does unstable writes but it does do
>> fsync() on FLUSH.

On Thu, Jun 16, 2011 at 8:41 AM, Pekka Enberg <penberg@kernel.org> wrote:
> Yes. That's fine, right? Or did we misread how virtio block devices
> are supposed to work?

And btw, we use sync_file_range() to make sure the metadata part of a
QCOW2 image is never corrupted. The rational here is that if the guest
doesn't do VIRTIO_BLK_T_FLUSH, you can corrupt your _guest filesystem_
but the _image_ will still work just fine and you can do fsck on it.

Also, Prasad ran xfstests and did over-night stress tests to iron out
corruption issues. Now we obviously can't promise that we'll never eat
your data but I can assure you that we've done as much as we've been
able to with the resources we have at the moment.

                                Pekka
