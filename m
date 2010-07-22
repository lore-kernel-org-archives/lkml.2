Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0GVIGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:06:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59034 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0GVIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:06:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JEkmBQ5H7QWOXkqtGXTdXWGGHEYj4eyo7tA7b7ZI2XIIqpjytE8zrkhZJw7Z1C7ffK
         wFQknvPKmjcEwxal92EWdsELur0hJDtjZivi/uKx+PkesmEDRexn/4gxEousJjptktDb
         yYzFISQYoZ0VPtvFzbRJA1vxRusLVHWJX6fVs=
Message-ID: <4C47FBEA.2000704@gmail.com>
Date: Thu, 22 Jul 2010 10:06:02 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: BUG at drivers/scsi/scsi_lib.c:1113
References: <4C47ED7B.1050709@gmail.com> <20100722173716.66264bef@notabene>
In-Reply-To: <20100722173716.66264bef@notabene>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 09:37 AM, Neil Brown wrote:
> I suspect that problem is that "do_sync" and "do_barriers" in
> drivers/md/raid1.c are still 'bool' and should now be 'unsigned long'.
> 
> I'm not sure how wide '_Bool' is, but I'm guess it isn't wide enough.

ANSI says:
An object declared as type _Bool is large enough to store the values 0
and 1.

gcc spec doesn't say anything, but:
$ gcc -S -x c -o - -
unsigned long x = sizeof(_Bool);
^D
...
x:
        .quad   1

I.e. sizeof(_Bool) = 1 byte.

> Could you please try changing ever 'bool' in that file to 'unsigned long'
> and see if that fixes it?

Will do that.

thanks,
-- 
js
