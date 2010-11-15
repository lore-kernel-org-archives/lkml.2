Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab0KOC1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 21:27:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60914 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab0KOC1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 21:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w07QceV7Ho6PBCt7l9dAW7F4B09CmJqAm+A0a82h5eqTMRyOZAtX+nua6yU6gbCNgs
         rYUY9rm59JCOtaemeasnNy/g8pnn0lcdTcHD4OJ82nCrw3RJJY2VwLWQ/c8acPLZEFP1
         MXmlljqHeF0lEylgQX5470tv0ArXML+rwND1M=
MIME-Version: 1.0
In-Reply-To: <4CDEA53E.2050602@gmail.com>
References: <4CDEA53E.2050602@gmail.com>
Date: Mon, 15 Nov 2010 10:27:10 +0800
Message-ID: <AANLkTiky=Vnxnav4VtX_Yd1sUtFGqHTrd=aih8qRJ7u7@mail.gmail.com>
Subject: Re: [PATCH 02/16 v3] pramfs: super operations
From: yidong zhang <zhangyd6@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tim.bird@am.sony.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Marco

> +       retval = 0;
> + out:
> +       if (retval && sbi->virt_addr) {
> +               iounmap(sbi->virt_addr);
> +               release_mem_region(sbi->phys_addr, initsize);
> +               kfree(sbi);
> +       }
> +
> +       return retval;
> +}
> +
  I think kfree(sbi) should not be put here. In case of
pram_parse_options failure, sbi should also be freed too.  How about
change it to the list below? And change some “goto out”   branches to
“goto out_free”.

 //    retval = 0;
     return 0;
 out:
       if (retval && sbi->virt_addr) {
               iounmap(sbi->virt_addr);
               release_mem_region(sbi->phys_addr, initsize);
       }
out_free:
               kfree(sbi);
       return retval;
}
