Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0H2Njb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:39:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34019 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0H2Nj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=CRo+MdIRLQfFH1iGE70C0iBHkrfNxIQeDNpMHO0bNPXfzl+b21/vpf9bKv38HOPG9D
         +3a33IahqrLFanDUU/wMLOGwTgtsQPd4wCQgpYqSDBH3cDDjlJ0qF7eJVhrfVYw1O111
         MPJkNSbxLOXOBaZLYTtMxfqdpJNPsthqUafFk=
MIME-Version: 1.0
In-Reply-To: <4C784544.2010305@zytor.com>
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com>
 <4C780888.9000301@zytor.com> <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com>
 <4C7824F2.1050709@mandriva.org> <AANLkTinjHK-oTmt-6cmN16jWWv9ZjW44wA-A3VTLm+A_@mail.gmail.com>
 <4C784544.2010305@zytor.com>
From: Matteo Croce <matteo@openwrt.org>
Date: Sun, 29 Aug 2010 15:39:09 +0200
X-Google-Sender-Auth: Gu0JyN4Bpea7ufJ9wtA-gFvmq8k
Message-ID: <AANLkTikaRkwPqB0u3OWknKpG2grZmDR976CBVz7jyVWC@mail.gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Natale Vinto <ebballon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 1:07 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/27/2010 02:32 PM, Matteo Croce wrote:
>> can I ignore the return value when I expect val to be non zero?
>> the doc says: "On error, the variable @x is set to zero."
>
> No.  You need to deliver a page fault to the application in this case.
>
> The *real* test for this kind of crap is correct page fault behavior,
> and so forth.
>
> Also, at the very least you need to check for:
>
> - CS == USER_CS
> - IP in the proper range for user space
>
> Your patch in its current form is one big security hole.
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>

If the parsing fails due get_user returning error I call
`do_invalid_op(regs, error_code);`
which is the default handler, which does the page fault.
to check the CS I do `regs->cs != __USER_CS` but how to check the IP value?
convert_ip_to_linear() and then check something?

-- 
Matteo Croce
OpenWrt developer
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 KAMIKAZE (bleeding edge) ------------------
  * 10 oz Vodka       Shake well with ice and strain
  * 10 oz Triple sec  mixture into 10 shot glasses.
  * 10 oz lime juice  Salute!
 ---------------------------------------------------
