Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0IZQ4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 12:56:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36481 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0IZQ4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 12:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=nwPbAgamp9Rw1u53eyru37ktX7mg7LLFU8pU6m3km9JmPBZrJz/9tzaZmUBddtwq00
         z9yUuRU6yk9rnm2YITz+Ntr99wB1/1RmC/+aOhsA6Sm2/aBB4RLhG7lDkCk9yOEUo+tw
         P0XiFGMkEtRUtN9qegMOPa5blMnTv7EqAyCb4=
MIME-Version: 1.0
In-Reply-To: <20100926131151.GC6134@bicker>
References: <1285491595-377-1-git-send-email-segooon@gmail.com>
	<20100926131151.GC6134@bicker>
Date: Sun, 26 Sep 2010 18:56:53 +0200
Message-ID: <AANLkTin_4D6fF85+4dFe+qN9-nEBS8+oDMKRCtixMCPU@mail.gmail.com>
Subject: Re: [PATCH] staging: ft1000: fix error path
From: Belisko Marek <marek.belisko@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Vasiliy Kulikov <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 3:11 PM, Dan Carpenter <error27@gmail.com> wrote:
> On Sun, Sep 26, 2010 at 12:59:55PM +0400, Vasiliy Kulikov wrote:
>> +err_free:
>> +     for (i--; i>=0; i--) {
>> +             kfree(pdpram_blk->pbuffer);
>> +             kfree(pdpram_blk);
>> +     }
>
> This is wrong.  I don't have linux-next so I can't see the context, why
> are we looping here?  The second iteration through the loop will cause a
> NULL dereference.
Some lines upper there is allocation of structure and it's internal
buffer in loop:
for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
    // Get memory for DPRAM_DATA link list
    pdpram_blk = kmalloc ( sizeof(DPRAM_BLK), GFP_KERNEL );
    // Get a block of memory to store command data
    pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
    // link provisioning data
    list_add_tail (&pdpram_blk->list, &freercvpool);
}

Free loop is correct in my opinion but kfree should be extended by checking
of NULL pointer because allocation of pdpram_blk could fail and we free also
pdpram_blk->pbuffer.
>
> Also there should be spaces before and after the ">=".
>
> regards,
> dan carpenter
>
>> +     return STATUS_FAILURE;
>>  }
>>
>
>

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
