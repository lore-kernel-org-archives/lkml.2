Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1DDSOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:14:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37376 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab1DDSOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=AVnuijzqgHxY96Ctpak+ISa+ClkqxA+2IoC7b+pBRW/4eC+R9aJyVsKtaQGIjDvifi
         9jYmTMmZ47BftgSVNIQ6UEkubuh/CXFb9bn9igsjnG8m2Bp2uuwD0Gau7VuJzjA7AMfb
         NhSTosvnM2MFxjiF1TNwOIQ7qPT6NBJspwjNY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1301940613.1941.50.camel@Joe-Laptop>
References: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
	<20110404130036.GB16669@srcf.ucam.org>
	<c428cc13a1a5953be3310237e4f404ec65968d5a.1301936559.git.joe@perches.com>
	<BANLkTinKXtiNE=4xfNMh+nJBpiYUYFNRZQ@mail.gmail.com>
	<1301940613.1941.50.camel@Joe-Laptop>
Date: Mon, 4 Apr 2011 20:14:05 +0200
Message-ID: <BANLkTimEt32ZOjNRd4h2uXd1Z-8W6yfg_Q@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] thinkpad_acpi: Convert printks to pr_<level>
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 8:10 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2011-04-04 at 20:03 +0200, Sedat Dilek wrote:
>> On Mon, Apr 4, 2011 at 7:06 PM, Joe Perches <joe@perches.com> wrote:
>> > diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
>> [...]
>> >  #ifdef CONFIG_THINKPAD_ACPI_DEBUG
>> >  #define vdbg_printk dbg_printk
>> >  static const char *str_supported(int is_supported);
>> >  #else
>> > -#define vdbg_printk(a_dbg_level, format, arg...) \
>> > -       do { } while (0)
>> > +static inline const char *str_supported(int is_supported) { return ""; }
>> > +#define vdbg_printk(a_dbg_level, format, arg...)       \
>> > +       no_printk(format, ##arg)
>> >  #endif
>>
>> Should be...
>> +       do { } while (0)
>> ...not...
>> +       no_printk(format, ##arg)
>
> I disagree.  No printk serves as a mechanism to verify
> printk arguments when !CONFIG_THINKPAD_ACPI_DEBUG.
>

Oops sorry, now I see you have chosen solution #1 :-).

- Sedat -
