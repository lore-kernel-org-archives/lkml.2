Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2EUKKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:10:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:14829 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab2EUKKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:10:15 -0400
Message-ID: <4FBA1483.4010008@atmel.com>
Date: Mon, 21 May 2012 12:10:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <maxime.ripard@free-electrons.com>,
        <olof@lixom.net>
Subject: Re: [PATCH] ARM: at91: Add ADC driver to at91sam9260/at91sam9g20
 dtsi files
References: <4FB3B1F3.6080102@atmel.com> <1337182626-13033-1-git-send-email-nicolas.ferre@atmel.com> <201205161850.54765.arnd@arndb.de> <20120517150601.GA28104@kroah.com> <20120518084446.a7b229074ea215fd7bcd1eb8@canb.auug.org.au>
In-Reply-To: <20120518084446.a7b229074ea215fd7bcd1eb8@canb.auug.org.au>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/18/2012 12:44 AM, Stephen Rothwell :
> Hi all,
> 
> On Thu, 17 May 2012 08:06:01 -0700 Greg KH
> <gregkh@linuxfoundation.org> wrote:
>> 
>> On Wed, May 16, 2012 at 06:50:54PM +0000, Arnd Bergmann wrote:
>>> On Wednesday 16 May 2012, Nicolas Ferre wrote:
>>>> Now that the bulk of at91sam9g20-related nodes are located in
>>>> at91sam9260.dtsi, we have to re-create the path to this ADC
>>>> node for SoC specific parts.
>>>> 
>>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> 
>>> Should we apply this patch in arm-soc so that Greg can drop the
>>> hunk that no longer applies?
>> 
>> It's not a "no longer applies", it's a "this does not merge".
>> The patch is in my tree, unless you want me to revert it, it's
>> going to stay there until it goes to Linus.
> 
> Just apply the patch to the arm-soc tree - then the merge
> resolution becomes "use the arm-soc version".   There is no need
> for Greg to revert the other patch.

Hi Stephen,

After checking the current status of
arch/arm/boot/dts/at91sam9g20.dtsi in linux-next, it seems the merge
resolution has not produced a good result:

The "adc0" node, should only look like:

ahb {
        apb {
                adc0: adc@fffe0000 {
                        atmel,adc-startup-time = <40>;
                };
        };
};

without the redundant code carried by the staging git tree. In short,
the arm-soc version is the proper one.

Thanks for your help, best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPuhR7AAoJEAf03oE53VmQW4wH/0lqpqrTujJ/dQ0z5Ku7Xde3
EKKJm51AIlIadOXiteYH6cw34ISm68cXZWpkbKh3UKiCcJGSJi4VjCrkcJ//CwUL
B4bZD3A6Y8zLQ+TaQbjMnfzKq2dOBRQ1M1dNoQXwPe83vjV85T4hoKco7LBhGhUI
l//0aWrcefH9sQynAYRhNE0M6hlfr/Edlia0zHlkVYqE2K5ALxaH6lki2EUzxvJC
l8qydZ9lum37ebnot09WB2qhIlkRApb50sYbQG4nMwlC3jSblXrPelQvChWLo/yi
JOPOF7Lcj9fnJmeVGlQknobilgWmRnuVQUbqBG4NjDx71k5WiEywF6ymBa8TJnA=
=rnQu
-----END PGP SIGNATURE-----
