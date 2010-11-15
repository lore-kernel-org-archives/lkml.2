Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0KOHqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:46:01 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56276 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab0KOHp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:45:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gbQUv1dqlo13ZCA0W7nk/WwLu14iQ5Ac8vxxHE9X2SwBH53vwSOqzibVf98UzPFO6o
         OdVDrFybLkEi1X8XHuTT2qACdd1EORyRXfZpvWojtgzzbs2bgJwf1+pO3yJqRr2fsIE3
         cNuk2b9OXCIziROg96QPcdXk7q3Fv0b2SU788=
MIME-Version: 1.0
In-Reply-To: <AANLkTiky=Vnxnav4VtX_Yd1sUtFGqHTrd=aih8qRJ7u7@mail.gmail.com>
References: <4CDEA53E.2050602@gmail.com>
	<AANLkTiky=Vnxnav4VtX_Yd1sUtFGqHTrd=aih8qRJ7u7@mail.gmail.com>
Date: Mon, 15 Nov 2010 08:45:56 +0100
Message-ID: <AANLkTimn=Yp-tzb6f-=M73+1Rjqbtp+fxWLH4bz7HEuJ@mail.gmail.com>
Subject: Re: [PATCH 02/16 v3] pramfs: super operations
From: Marco Stornelli <marco.stornelli@gmail.com>
To: yidong zhang <zhangyd6@gmail.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tim.bird@am.sony.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/15 yidong zhang <zhangyd6@gmail.com>:
> hi Marco
>
>> +       retval = 0;
>> + out:
>> +       if (retval && sbi->virt_addr) {
>> +               iounmap(sbi->virt_addr);
>> +               release_mem_region(sbi->phys_addr, initsize);
>> +               kfree(sbi);
>> +       }
>> +
>> +       return retval;
>> +}
>> +
>  I think kfree(sbi) should not be put here. In case of
> pram_parse_options failure, sbi should also be freed too.  How about
> change it to the list below? And change some “goto out”   branches to
> “goto out_free”.
>
>  //    retval = 0;
>     return 0;
>  out:
>        if (retval && sbi->virt_addr) {
>                iounmap(sbi->virt_addr);
>                release_mem_region(sbi->phys_addr, initsize);
>        }
> out_free:
>                kfree(sbi);
>        return retval;
> }
>

Yeah, you're right. It's not always true that virt addr is valid,
kfree should be used out of this if. I'll fix it.

Marco
